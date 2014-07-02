//
//  DMCScanController.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-24.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCScanController.h"
#import "DMCScanCollection.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "RcpApi.h"

@implementation DMCScanController {
    RcpApi *_rcp;
    CTCallCenter *callCenter;
}

-(instancetype)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(appWillEnterForeground:)
         name:UIApplicationWillEnterForegroundNotification
         object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(instancetype)instance {
    static DMCScanController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DMCScanController alloc] init];
        instance.collection = [[DMCScanCollection alloc] init];
    });
    return instance;
}

-(void)appWillEnterForeground:(NSNotification *)notification {
    //[self start];
}

-(void)setup {
    
    // check for mic permission
#ifndef __IPHONE_7_0
    typedef void (^PermissionBlock)(BOOL granted);
#endif
    
    PermissionBlock permissionBlock = ^(BOOL granted) {
        if (granted) {
            
        } else {
            NSString *message = @"Microphone input permission refused. Go to iOS settings to enable permission.";
            NSString *title = @"Hardware Error";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
            });
        }
    };
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:)
                                              withObject:permissionBlock];
    }
    
    [self.rcp open];
}


- (RcpApi *)rcp
{
    if(!_rcp)
    {
        _rcp = [[RcpApi alloc] init];
        _rcp.delegate = self;
        __weak RcpApi *pRcp = _rcp;
        __weak DMCScanController * pSelf = self;
        
        callCenter = [[CTCallCenter alloc] init];
        callCenter.callEventHandler = ^(CTCall *call) {
            NSLog(@"call.callState = %@", call.callState);
            
            if((call.callState == CTCallStateIncoming)
               || (call.callState == CTCallStateDialing)
               || (call.callState == CTCallStateConnected)
               || ( call.callState == CTCallStateDisconnected ))
            {
                if([pRcp isOpened])
                    [pRcp close];
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   NSLog(@"Scan interupted by cell");
                                   // looks like reset the app to not scanning?
                                   [pSelf.delegate endScanning];
                                   //[pSelf displayClose];
                                   //[pSelf.olSwitch setOn:NO];
                               });
            }
        }; // call event handler
        
    }
    
    return _rcp;
}

- (void)start {
    NSLog(@"Starting scanning");
    
    RcpApi *rcp = [self rcp];
	
    if(![rcp isOpened]) {
        [rcp open];
    }
    
    if (![self.rcp isOpened]) {
        NSLog(@"RCP isn't open yet, sleeping");
        return;
    }
    
    int stopTagCount = (self.session ? 1 : 0); // if there is a session, cancel after 1, otherwise infinite.
    int stopTime = 0;
    int stopCycle = 0;
    BOOL rssiOn = NO;
    
    if (self.plugged) {
        if(!rssiOn) {
            [rcp startReadTags:stopTagCount mtime:stopTime repeatCycle:stopCycle];
        } else {
            [rcp startReadTagsWithRssi:stopTagCount mtime:stopTime repeatCycle:stopCycle];
        }
    }
    
    [self.delegate beginScanning];
}

-(void)stop {
    [self.rcp stopReadTags];
    
    [self.delegate endScanning];
}

-(void)teardown {
    [self.rcp stopReadTags];
    self.session = nil;
    [self.rcp close];
    [self.delegate endScanning];
}

- (IBAction)muteSwitch:(UISwitch *)sender {
    if([sender isOn]) {
        NSLog(@"On\n");
        
        if([self.rcp open]) {
            //self.olBtnRead.enabled = YES;
            //self.olBtnClear.enabled = YES;
            //self.olBtnStop.enabled = YES;
        }
        //self.olBtnSettings.enabled = YES;
        
        if(1.0 != [[AVAudioSession sharedInstance] outputVolume]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Set the maximum volume."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        [self.rcp close];
        //[self displayClose];
    }
}

-(void)handleScan:(DMCScan *)scan { // called by RcpDelegate method below, and by DMCAppDelegate when in simulation mode
    [self.collection addScan:scan];
    if (self.session) {
        NSURL *url = [self.session callbackUrlWithScan:scan];
        
        [self.delegate endScanning];
        
        if (url) {
            NSLog(@"Opening url %@", url);
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"error, invalid callback url");
        }
        self.session = nil;
        [self.rcp stopReadTags];
    }
    
}


#pragma mark - Check if plugged

- (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    
    BOOL headphonesLocated = NO;
    for( AVAudioSessionPortDescription *portDescription in route.outputs )
    {
        headphonesLocated |= ( [portDescription.portType isEqualToString:AVAudioSessionPortHeadphones] );
    }
    return headphonesLocated;
}

#pragma mark - RcpDelegate

- (void)plugged:(BOOL)plug {
    self.plugged = plug;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusChanged" object:nil];
    
    NSLog(@"plug change: %@", (plug ? @"Plugged" : @"Unplugged"));
}

- (void)pcEpcReceived:(NSData *)pcEpc {
    NSLog(@"pcEpcReceived: %@", pcEpc);
    
    DMCScan *scan = [[DMCScan alloc] init];
    scan.rawPcEpc = pcEpc;
    scan.scanDate = [NSDate date];
    
    [self handleScan:scan];
}

- (void)pcEpcRssiReceived:(NSData *)pcEpc rssi:(int8_t)rssi {
    NSLog(@"pcEpcRssiReceived");
}

- (void)readerConnected {
    NSLog(@"ReaderConnected");
}

- (void)ackReceived:(uint8_t)commandCode {
    NSLog(@"ackReceived: %i", commandCode);
}

- (void)errReceived:(uint8_t)errCode {
    NSLog(@"errReceived");
}

- (void)readerInfoReceived:(NSData *)data {
    NSLog(@"readerInfoReceived");
}

- (void)regionReceived:(uint8_t)region {
    NSLog(@"regionReceived");
}

- (void)selectParamReceived:(NSData *)selParam {
    NSLog(@"selectParamReceived");
}

- (void)queryParamReceived:(NSData *)qryParam {
    NSLog(@"queryParamReceived");
}

- (void)channelReceived:(uint8_t)channel channelOffset:(uint8_t)channelOffset {
    NSLog(@"channelReceived:channelOffset");
}

- (void)fhLbtReceived:(NSData *)fhLb {
    NSLog(@"fhLbtReceived");
}

- (void)txPowerLevelReceived:(uint8_t)power {
    NSLog(@"txPowerLevelReceived");
}

- (void)tagMemoryReceived:(NSData *)data {
    NSLog(@"tagMemoryReceived");
}

- (void)hoppingTableReceived:(NSData *)table {
    NSLog(@"hoppingTableReceived");
}

- (void)modulationParamReceived:(uint8_t)param {
    NSLog(@"modulationParamReceived");
}

- (void)anticolParamReceived:(uint8_t)param {
    NSLog(@"anticolParamReceived");
}

- (void)tempReceived:(uint8_t)temp {
    NSLog(@"tempReceived");
}

- (void)rssiReceived:(uint16_t)rssi {
    NSLog(@"rssiReceived");
}

- (void)registeryItemReceived:(NSData *)item {
    NSLog(@"registeryItemReceived");
}

- (void)adcReceived:(NSData*)data {
    NSLog(@"adcReceived: %@", data);
    if (self.session && ![self.session started]) {
        self.session.started = YES;
        [self start];
    }
}

- (void)genericReceived:(NSData*)data {
    NSLog(@"genericReceived");
}



@end

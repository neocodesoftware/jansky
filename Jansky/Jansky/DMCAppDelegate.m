//
//  DMCAppDelegate.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCAppDelegate.h"

#import "DMCScanController.h"


@implementation DMCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    DMCScanController *scanController = [DMCScanController instance];
    [scanController teardown];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    DMCScanController *scanController = [DMCScanController instance];
    [scanController setup];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// rfid://scan?callback=fmp%3A//%24/filename%3Fscript%3DScan%26param%3DEAN
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    DMCSession *session = [[DMCSession alloc] init];
    session.originalCall = url;
    DMCScanController *scanController = [DMCScanController instance];
    scanController.session = session;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"simulationMode"]) {
        [self handleSimulation];
    }
    // scanning start is handled by DMCScanController's adcReceived method.
    return YES;
}

-(void)handleSimulation {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simulation Mode" message:@"Enter a code, it will be returned to the calling app using the url callback provided." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DMCScanController *scanner = [DMCScanController instance];
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        // behave as though the text input was scanned.
        UITextField *inputField = [alertView textFieldAtIndex:0];
        
        DMCScan *scan = [[DMCScan alloc] init];
        scan.string = inputField.text;
        scan.scanDate = [NSDate date];
        [scanner handleScan:scan];
    } else {
        scanner.session = nil;
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    UITextField *inputField = [alertView textFieldAtIndex:0];
    
    return [[inputField text] length] > 0;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end

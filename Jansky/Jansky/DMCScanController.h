//
//  DMCScanController.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-24.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RcpApi.h"

#import "DMCSession.h"
#import "DMCScan.h"
@class DMCScanCollection;

@protocol DMCScanControllerDelegate <NSObject>

-(void)beginScanning;
-(void)endScanning;

@end

@interface DMCScanController : NSObject <RcpDelegate>

@property (nonatomic, strong) DMCScanCollection *collection;
@property (nonatomic, strong) DMCSession *session;

@property (nonatomic, weak) id <DMCScanControllerDelegate> delegate;

@property (readwrite) BOOL plugged;

+(instancetype)instance;

- (RcpApi *)rcp;

- (void)setup;
- (void)start;
- (void)stop;
-(void)teardown;

-(void)handleScan:(DMCScan *)scan;

@end

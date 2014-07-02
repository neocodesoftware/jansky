//
//  DMCSession.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMCScan;

@interface DMCSession : NSObject

@property (nonatomic, strong) NSURL *originalCall;
@property (readonly) BOOL simulationMode;
@property (readonly) NSString *callback;
@property (readwrite) BOOL started;

-(NSURL *)callbackUrlWithScan:(DMCScan *)scan; // generate a callback url using the scan.

@end

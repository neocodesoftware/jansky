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

@interface DMCScanController : NSObject <RcpDelegate>

@property (nonatomic, strong) DMCSession *session;

+(instancetype)instance;

- (RcpApi *)rcp;

- (void)setup;
- (void)start;

@end

//
//  DMCScan.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCScan : NSObject

@property (nonatomic, strong) NSData *rawPcEpc;
@property (nonatomic, strong) NSString *string;

@property (nonatomic, strong) NSDate *scanDate;
@property (nonatomic, strong) NSNumber *count;

-(void)incrementCount;

-(NSString *)identifier;

@end

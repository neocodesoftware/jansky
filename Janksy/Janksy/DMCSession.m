//
//  DMCSession.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCSession.h"
#import "NSURL+Params.h"

#import "DMCScan.h"

@implementation DMCSession

-(NSURL *)callbackUrlWithScan:(DMCScan *)scan {
    NSDictionary *params = [self.originalCall params];
    NSString *callback = [params objectForKey:@"callback"];
    
    NSLog(@"Callback is %@", callback);
    
    NSString *decoded = (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)callback, CFSTR(""), kCFStringEncodingUTF8);
    
    NSURL *callbackUrl = [NSURL URLWithString:decoded];
    
    NSDictionary *cbParams = [callbackUrl params];
    NSString *cbParamName = [cbParams objectForKey:@"param"];
    
    NSString *callbackUrlString = [callbackUrl absoluteString];
    NSString *codedCallbackUrlString = [callbackUrlString stringByAppendingFormat:@"&%@=%@",cbParamName, [scan identifier]];
    
    NSURL *codedCallbackUrl = [NSURL URLWithString:codedCallbackUrlString];
    
    return codedCallbackUrl;
}

@end

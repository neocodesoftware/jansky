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
    
    NSMutableString *callbackUrlString = [[NSMutableString alloc] initWithFormat:@"%@://%@/%@?", [callbackUrl scheme], [callbackUrl host], [callbackUrl path]];
    
    BOOL touched = NO;
    BOOL appended = NO;
    
    for (NSString *paramName in [cbParams allKeys]) {
        
        if (touched) {
            [callbackUrlString appendString:@"&"];
        } else {
            touched = YES;
        }
        
        if ([paramName isEqualToString:@"param"]) {
            [callbackUrlString appendFormat:@"param=%@", [scan identifier]];
            appended = YES;
        } else {
            id value = cbParams[paramName];
            if (value == [NSNull null]) {
                [callbackUrlString appendString:paramName];
            } else {
                [callbackUrlString appendFormat:@"%@=%@", paramName, value];
            }
        }
    }
    
    if (!appended) {
        if (touched) {
            [callbackUrlString appendString:@"&"];
        }
        
        [callbackUrlString appendFormat:@"param=%@", [scan identifier]];
    }
    
    //NSString *callbackUrlString = [[[callbackUrl absoluteString] componentsSeparatedByString:@"?"] firstObject];
    //NSString *codedCallbackUrlString = [callbackUrlString stringByAppendingFormat:@"&%@=%@",cbParamName, [scan identifier]];
    
    NSURL *codedCallbackUrl = [NSURL URLWithString:callbackUrlString];
    
    return codedCallbackUrl;
}

@end

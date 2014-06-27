//
//  DMCSession.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCSession.h"
#import "NSURL+Params.h"

@implementation DMCSession

-(NSURL *)callbackUrlWithScan:(DMCScan *)scan {
    NSDictionary *params = [self.originalCall params];
    NSString *callback = [params objectForKey:@"callback"];
    
    NSLog(@"Callback is %@", callback);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@", callback];
    
    NSString *encoded = @"fields=ID%2CdeviceToken";
    NSString *decoded = (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)urlString, NULL, NSUTF8StringEncoding);
    
    NSURL *callbackUrl = [NSURL URLWithString:decoded];
    
    
    
    return callbackUrl;
}

@end

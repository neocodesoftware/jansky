//
//  NSURL+Params.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-26.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "NSURL+Params.h"

@implementation NSURL (Params)

-(NSDictionary *)params {
    NSString *query = [self query];
    NSArray *paramSets = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *paramSet in paramSets) {
        NSArray *paramComponents = [paramSet componentsSeparatedByString:@"="];
        if ([paramComponents count] > 0) {
            NSString *paramName = paramComponents[0];
            
            id paramValue = [NSNull null];
            
            if ([paramComponents count] > 1) {
                paramValue = paramComponents[1];
            }
            
            [params setObject:paramValue forKey:paramName];
        }
    }
    return params;
}

@end

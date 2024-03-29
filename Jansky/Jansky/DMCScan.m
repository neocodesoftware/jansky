//
//  DMCScan.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCScan.h"

@implementation DMCScan

-(instancetype)init {
    if ((self = [super init])) {
        self.count = @(1);
    }
    return self;
}

-(void)incrementCount {
    if (self.count) {
        self.count = @([self.count integerValue] + 1);
    } else {
        self.count = @(1);
    }
}

-(NSString *)identifier {
    NSString *rawString = self.string;
    if (self.rawPcEpc) {
        NSData *data = self.rawPcEpc;
        NSUInteger dataLength = [data length];
        NSMutableString *string = [NSMutableString stringWithCapacity:dataLength*2];
        const unsigned char *dataBytes = [data bytes];
        for (NSInteger idx = 0; idx < dataLength; ++idx) {
            [string appendFormat:@"%02x", dataBytes[idx]];
        }
        rawString = string;
    }
    
    NSMutableCharacterSet * URLQueryPartAllowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [URLQueryPartAllowedCharacterSet removeCharactersInRange:NSMakeRange('&', 1)]; // %26
    [URLQueryPartAllowedCharacterSet removeCharactersInRange:NSMakeRange('=', 1)]; // %3D
    [URLQueryPartAllowedCharacterSet removeCharactersInRange:NSMakeRange('?', 1)]; // %3F
    
    return [rawString stringByAddingPercentEncodingWithAllowedCharacters:URLQueryPartAllowedCharacterSet];
}



@end

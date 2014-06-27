//
//  DMCScanCollection.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCScanCollection.h"

@implementation DMCScanCollection

-(instancetype)init {
    if ((self = [super init])) {
        self.scans = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

-(void)addScan:(DMCScan *)scan {
    NSAssert(scan, @"Missing a scan object, dont call this with nil.");
    NSAssert([scan isKindOfClass:[DMCScan class]], @"Object is not an instance of DMCScan.");
    
    BOOL exists = NO;
    for (DMCScan *existingScan in self.scans) {
        if ([existingScan.identifier isEqualToString:scan.identifier]) {
            exists = YES;
            [existingScan incrementCount];
            existingScan.scanDate = scan.scanDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectionChange" object:nil];
            break;
        }
    }
    
    if (!exists) {
        [self.scans insertObject:scan atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectionInsert" object:nil];
    }
}

-(void)sortByDate {
    [self.scans sortUsingComparator:^NSComparisonResult(DMCScan *obj1, DMCScan *obj2) {
        return [obj1.scanDate compare:obj2.scanDate];
    }];
}

@end

//
//  DMCScanCollection.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMCScan.h"

@interface DMCScanCollection : NSObject

@property (nonatomic, strong) NSMutableArray *scans;

-(void)addScan:(DMCScan *)scan;

-(void)sortByDate;

@end

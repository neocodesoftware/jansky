//
//  DMCDedicationViewController.m
//  Jansky
//
//  Created by Cory Alder on 2014-07-23.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCDedicationViewController.h"

@interface DMCDedicationViewController ()

@end

@implementation DMCDedicationViewController

-(IBAction)openWikipedia:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Karl_Guthe_Jansky"]];
}

@end

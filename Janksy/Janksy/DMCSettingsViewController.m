//
//  DMCSettingsViewController.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-25.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCSettingsViewController.h"

@interface DMCSettingsViewController ()

@end

@implementation DMCSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)simulationSwitchAction:(id)sender {
    NSLog(@"Simulation mode switch");
}

@end

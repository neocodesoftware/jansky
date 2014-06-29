//
//  DMCSettingsViewController.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-25.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCSettingsViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UISwitch *simulationSwitch;

@property (nonatomic, strong) id observer;

-(IBAction)simulationSwitchAction:(id)sender;

@end

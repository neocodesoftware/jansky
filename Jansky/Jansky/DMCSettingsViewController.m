//
//  DMCSettingsViewController.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-25.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCSettingsViewController.h"

#import "DMCScanController.h"
#import "RcpApi.h"
#import <AVFoundation/AVFoundation.h>

@interface DMCSettingsViewController ()

@end

@implementation DMCSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
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
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    __weak typeof(self) weakSelf = self;
    
    self.observer = [nc addObserverForName:@"StatusChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        [weakSelf updateStatus];
        [weakSelf updateSimulation];
    }];
    
}

-(void)viewDidUnload {
    if (self.observer) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.observer];
        self.observer = nil;
    }
}

-(void)updateStatus {
    DMCScanController *scanController = [DMCScanController instance];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SimulationMode"]) {
        self.statusLabel.text = @"Simulation Mode";
        self.statusLabel.textColor = [UIColor orangeColor];
    } else if (![scanController.rcp isOpened]) {
        self.statusLabel.text = @"Reader unreachable";
        self.statusLabel.textColor = [UIColor redColor];
    } else {
        if ([scanController plugged]) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if(audioSession && [audioSession outputVolume] == 1.0) {
                self.statusLabel.text = @"Good";
                self.statusLabel.textColor = [UIColor greenColor];
            } else {
                self.statusLabel.text = [NSString stringWithFormat:@"Volume low (%i%%)", (int)([audioSession outputVolume] * 100)];
                self.statusLabel.textColor = [UIColor orangeColor];
            }
                    
            
        } else {
            self.statusLabel.text = @"Unplugged";
            self.statusLabel.textColor = [UIColor orangeColor];
        }
    }
}

-(void)updateSimulation {
    BOOL sim = [[NSUserDefaults standardUserDefaults] boolForKey:@"SimulationMode"];
    [self.simulationSwitch setOn:sim animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateStatus];
    [self updateSimulation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)simulationSwitchAction:(id)sender {
    //NSLog(@"Simulation mode switch");
    [[NSUserDefaults standardUserDefaults] setBool:self.simulationSwitch.on forKey:@"SimulationMode"];
    
    DMCScanController *scanner = [DMCScanController instance];
    if (self.simulationSwitch.on) {
        [scanner teardown];
    } else {
        [scanner setup];
    }
    
    [self updateStatus];
}

@end

//
//  DMCMasterViewController.h
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMCScanCollection, DMCScanController;

@interface DMCMasterViewController : UITableViewController

@property (nonatomic, strong) DMCScanCollection *collection;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *scanCancelButton;

-(IBAction)cancelButtonAction:(id)sender;
-(IBAction)scanButtonAction:(id)sender;

@end

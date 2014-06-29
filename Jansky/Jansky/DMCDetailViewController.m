//
//  DMCDetailViewController.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCDetailViewController.h"

#import "DMCScan.h"

@interface DMCDetailViewController ()
- (void)configureView;
@end

@implementation DMCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    DMCScan *scan = (DMCScan *)self.detailItem;
    
    if (scan) {
        self.detailDescriptionLabel.text = [scan identifier];
        self.detailDateLabel.text = [[scan scanDate] description];
        self.detailCountLabel.text = [NSString stringWithFormat:@"%@", [scan count]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DMCMasterViewController.m
//  Janksy
//
//  Created by Cory Alder on 2014-06-14.
//  Copyright (c) 2014 Davander Mobile Corporation. All rights reserved.
//

#import "DMCMasterViewController.h"

#import "DMCDetailViewController.h"

#import "DMCScanCollection.h"

#import "NSDate+DateTools.h"

#import "DMCScanController.h"

#import "DMCSession.h"

@implementation DMCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collection = [[DMCScanCollection alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    DMCScanController *scanner = [DMCScanController instance];
    [scanner setup];
    [scanner start];
    
    DMCSession *session = [[DMCSession alloc] init];
    session.originalCall = [NSURL URLWithString:@"pic2shop://scan?callback=fmp%3A//%24/filename%3Fscript%3DScan%26param%3DEAN"];
    scanner.session = session;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{

    DMCScan *scan = [[DMCScan alloc] init];
    scan.scanDate = [NSDate date];
    //scan.rawPcEpc = [[[NSUUID alloc] init] UUIDString];
    
    [_collection addScan:scan];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collection.scans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    DMCScan *object = _collection.scans[indexPath.row];
    cell.textLabel.text = [object identifier];
    cell.detailTextLabel.text = [object.scanDate timeAgoSinceNow];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_collection.scans removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DMCScan *scan = _collection.scans[indexPath.row];
        [[segue destinationViewController] setDetailItem:scan];
    }
}

#pragma mark - Button Actions

-(IBAction)cancelButtonAction:(id)sender {
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(scanButtonAction:)];
    
    NSUInteger index = [self.toolbarItems indexOfObject:sender];
    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    [toolbarItems replaceObjectAtIndex:index withObject:scanButton];
    
    [self setToolbarItems:toolbarItems animated:YES];
    self.scanCancelButton = scanButton;
}

-(IBAction)scanButtonAction:(id)sender {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
    
    NSUInteger index = [self.toolbarItems indexOfObject:sender];
    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    [toolbarItems replaceObjectAtIndex:index withObject:cancelButton];
    
    [self setToolbarItems:toolbarItems animated:YES];
    self.scanCancelButton = cancelButton;
}

@end

//
//  SEDScriptsTableViewController.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/22.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDScriptsTableViewController.h"

@interface SEDScriptsTableViewController ()
{
    NSArray *_files;
}
@end

@implementation SEDScriptsTableViewController

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
    _files = [[NSBundle mainBundle] pathsForResourcesOfType:@"sescript" inDirectory:@"Scripts.bundle"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[[_files objectAtIndex:indexPath.row] pathComponents] lastObject];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate scriptsController:self didSelectScriptPath:[_files objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

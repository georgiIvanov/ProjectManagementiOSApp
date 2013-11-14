//
//  InProjectViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/14/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "InProjectViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

#import "IssueViewController.h"

@interface InProjectViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation InProjectViewController
{
    NSArray* _sections;
    NSDictionary* _rows;
    
    IssueViewController* _issueController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sections = [self createSections];
    self.navigationItem.title = self.projectName;
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"openIssueSegue"])
    {
        _issueController = (IssueViewController*)segue.destinationViewController;
        _issueController.IsBeingOpened = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray* arr = [_rows valueForKey: [_sections objectAtIndex:section]];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell.
    NSString* key = [_sections objectAtIndex:indexPath.section];
    NSArray* rowsInSection = [_rows valueForKey:key];
    cell.textLabel.text =  [[rowsInSection objectAtIndex:indexPath.item] valueForKey:@"Username"] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    
}

-(void) handleError:(NSError *)error
{
    
}

-(NSArray*)createSections
{
    NSArray* createdSections = [[NSArray alloc]initWithObjects:@"Tasks",@"Notes",@"Issues", nil];
    return createdSections;
}

@end

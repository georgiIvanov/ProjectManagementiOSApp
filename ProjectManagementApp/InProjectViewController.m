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
    NSMutableDictionary* _rows;
    
    IssueViewController* _issueController;
    BOOL _reloadInformation;
    NSString* _answerIssueId;
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

    _rows = [[NSMutableDictionary alloc] init];
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
    [self getProjectInfo];
    _reloadInformation = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    if(!_reloadInformation)
    {
        _reloadInformation = YES;
        return;
    }
    
    [self getProjectInfo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _issueController = (IssueViewController*)segue.destinationViewController;
    _issueController.projectName = self.projectName;
    if([segue.identifier isEqualToString:@"openIssueSegue"])
    {
        _issueController.IsBeingOpened = YES;
    }
    else if([segue.identifier isEqualToString:@"answerIssueSegue"])
    {
        _issueController.IsBeingOpened = NO;
        _issueController.issueId = _answerIssueId;
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
    NSString* keySection = [_sections objectAtIndex:section];
    if([_rows objectForKey:keySection])
    {
        NSArray* arr = [_rows valueForKey: keySection];
        return [arr count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell.
    NSString* key = [_sections objectAtIndex:indexPath.section];
    NSArray* rowsInSection = [_rows valueForKey:key];
    cell.textLabel.text =  [[rowsInSection objectAtIndex:indexPath.item] valueForKey:@"Title"] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 2)
    {
        _answerIssueId = [[[_rows valueForKey:@"Issues"] objectAtIndex:indexPath.item] valueForKey:@"Id"];
        [self performSegueWithIdentifier:@"answerIssueSegue" sender:self];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Issues"])
    {
        NSArray* arr = [responseData valueForKey:@"Issues"];
        [_rows setValue:arr forKey:@"Issues"];
    }
    
    [self.tableViewOutlet reloadData];
    
}

-(void) handleError:(NSError *)error
{
    
}

-(NSArray*)createSections
{
    NSArray* createdSections = [[NSArray alloc]initWithObjects:@"Tasks",@"Notes",@"Issues", nil];
    return createdSections;
}

-(void) getProjectInfo
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Project/GetProjectInformation?projectName="];
    [url appendString:self.projectName];
    
    [RequestManager createAuthenticatedGet:url delegate:self];

}

- (IBAction)openIssueAction:(id)sender {
    [self performSegueWithIdentifier:@"openIssueSegue" sender:self];
}
@end

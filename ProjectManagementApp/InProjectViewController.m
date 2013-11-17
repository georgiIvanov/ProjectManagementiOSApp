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
#import "ReadNoteViewController.h"

@interface InProjectViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation InProjectViewController
{
    NSArray* _sections;
    NSMutableDictionary* _rows;
    
    IssueViewController* _issueController;
    ReadNoteViewController* _readNoteController;
    BOOL _reloadInformation;
    NSString* _entryId;
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
    [RequestManager setProjectName:self.projectName];
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
    
    if([segue.identifier isEqualToString:@"openIssueSegue"])
    {
        _issueController = (IssueViewController*)segue.destinationViewController;
        _issueController.projectName = self.projectName;
        _issueController.IsBeingOpened = YES;
    }
    else if([segue.identifier isEqualToString:@"answerIssueSegue"])
    {
        _issueController = (IssueViewController*)segue.destinationViewController;
        _issueController.projectName = self.projectName;
        _issueController.IsBeingOpened = NO;
        _issueController.issueId = _entryId;
    }
    else if([segue.identifier isEqualToString:@"readNoteSegue"])
    {
        _readNoteController = (ReadNoteViewController*)segue.destinationViewController;
        _readNoteController.noteId = _entryId;
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
    if(indexPath.section == 2)
    {
        _entryId = [[[_rows valueForKey:@"Issues"] objectAtIndex:indexPath.item] valueForKey:@"Id"];
        [self performSegueWithIdentifier:@"answerIssueSegue" sender:self];
    }
    else if(indexPath.section == 1)
    {
        _entryId = [[[_rows valueForKey:@"Notes"] objectAtIndex:indexPath.item] valueForKey:@"Id"];
        [self performSegueWithIdentifier:@"readNoteSegue" sender:self];
    }
    else if(indexPath.section == 0)
    {
        
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
        [_rows setValue:[responseData valueForKey:@"Notes"] forKey:@"Notes"];
        Role role =[[responseData valueForKey:@"UserRoleInProject"] integerValue];
        [RequestManager setRole:role];
        [self checkPermissions];
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
    [url appendString:@"Project/GetProjectInformation"];
    
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:self.projectName, @"ProjectName", nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

- (IBAction)openIssueAction:(id)sender {
    [self performSegueWithIdentifier:@"openIssueSegue" sender:self];
}

- (IBAction)createNoteAction:(id)sender {
    [self performSegueWithIdentifier:@"createNoteSegue" sender:self];
}

-(void)checkPermissions
{
    if([RequestManager getRole] >= PROJECT_MANAGER)
    {
        self.assignReportBtn.hidden = NO;
        self.createTaskBtn.hidden = NO;
        self.createNoteBtn.hidden = NO;
    }
}
@end

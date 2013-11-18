//
//  AllTasksViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/18/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "AllTasksViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
@interface AllTasksViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, HttpRequestDelegate>

@end

@implementation AllTasksViewController
{
    NSArray* _sections;
    NSMutableDictionary* _tasks;
    NSObject* _taskChosen;
    BOOL _userParticipatesInTask;
    BOOL _completedTaskChosen;
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
    _tasks = [[NSMutableDictionary alloc] init];
    [self getTasksForProject];
    self.tasksTable.delegate = self;
    self.tasksTable.dataSource = self;
    
	// Do any additional setup after loading the view.
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
    if([_tasks objectForKey:keySection])
    {
        NSArray* arr = [_tasks valueForKey: keySection];
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
    NSArray* rowsInSection = [_tasks valueForKey:key];
    
    UILabel* taskLabel = (UILabel*)[cell viewWithTag:1];
    UITextView* usersInTask = (UITextView*)[cell viewWithTag:2];
    
    taskLabel.text =  [[rowsInSection objectAtIndex:indexPath.item] valueForKey:@"TaskName"];
    NSArray* arr = [[rowsInSection objectAtIndex:indexPath.item] valueForKey:@"UsersParticipating"];
    usersInTask.text = [arr componentsJoinedByString:@", "];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tasks.count == 0)
    {
        return;
    }
    
    NSString* key = [_sections objectAtIndex:indexPath.section];
    NSObject* task = [[_tasks valueForKey:key] objectAtIndex: indexPath.item];
    NSString* username = [RequestManager getLoginName];
    
    _userParticipatesInTask = NO;
    for (NSString* user in [task valueForKey:@"UsersParticipating"]) {
        if([user compare:username] == NSOrderedSame)
        {
            _userParticipatesInTask = YES;
            break;
        }
    }
    
    _taskChosen = task;
    [self createAlertView:task];
    
}

-(void)createAlertView:(NSObject*)task
{
    UIAlertView *alert;
    _completedTaskChosen = NO;
    BOOL isTaskCompleted = [[task valueForKey:@"Completed"] boolValue];
    if(isTaskCompleted && [RequestManager getRole] >= ProjectManager)
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:[task valueForKey:@"TaskName"]
                 message:[task valueForKey:@"TaskDescription"]
                 delegate:self
                 cancelButtonTitle:@"Reopen"
                 otherButtonTitles:@"Cancel", nil];
        _completedTaskChosen = YES;

    }
    else if(!isTaskCompleted &&_userParticipatesInTask)
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:[task valueForKey:@"TaskName"]
                 message:[task valueForKey:@"TaskDescription"]
                 delegate:self
                 cancelButtonTitle:@"Complete"
                 otherButtonTitles:@"Cancel", @"Leave", nil];
    }
    else if(!isTaskCompleted)
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:[task valueForKey:@"TaskName"]
                 message:[task valueForKey:@"TaskDescription"]
                 delegate:self
                 cancelButtonTitle:@"Accept"
                 otherButtonTitles:@"Cancel", nil];
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_completedTaskChosen)
    {
        if(buttonIndex == 0)
        {
            [self reopenTask];
        }
    }
    else if(_userParticipatesInTask)
    {
        if(buttonIndex == 0) // complete
        {
            [self completeTask];
        }
        else if(buttonIndex == 2) // leave
        {
            [self removeFromTask];
        }
    }
    else
    {
        if(buttonIndex == 0)
        {
            [self assignForTask];
        }
    }
}


-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Open"])
    {
        [_tasks setValue:[responseData valueForKey:@"Open"] forKey:@"Open"];
        [_tasks setValue:[responseData valueForKey:@"Completed"] forKey:@"Completed"];
        [self.tasksTable reloadData];
    }
    else if([responseData objectForKey:@"Edited"])
    {
        [self getTasksForProject];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTasksForProject
{
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              [RequestManager getOrganizationName], @"OrganizationName",
                              [RequestManager getProjectName], @"ProjectName",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/AllTasksForProject"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
}

-(void)assignForTask
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/AssignForTask"];
    [self sendTaskRequest:url];
}

-(void)removeFromTask
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/RemoveFromTask"];
    
    [self sendTaskRequest:url];
}

-(void)completeTask
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/CompleteTask"];
    [self sendTaskRequest:url];
}

-(void)reopenTask
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/ReopenTask"];
    [self sendTaskRequest:url];
}

-(void)sendTaskRequest:(NSMutableString*)url
{
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              [_taskChosen valueForKey:@"Id"], @"TaskStringId",
                              nil];
    [RequestManager createAuthenticatedRequest:url httpMethod:@"PUT" sentData:sentData delegate:self];
}

-(NSArray*)createSections
{
    NSArray* createdSections = [[NSArray alloc]initWithObjects:@"Open",@"Completed", nil];
    return createdSections;
}

@end

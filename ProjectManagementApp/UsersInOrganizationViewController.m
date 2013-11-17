//
//  UsersInOrganizationViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/12/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "UsersInOrganizationViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "AdminUserProfileViewController.h"

@interface UsersInOrganizationViewController () <UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation UsersInOrganizationViewController
{
    NSArray* _sections;
    NSDictionary* _rows;
    NSString* _chosenUsername;
    AdminUserProfileViewController* _profileController;
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
    if(_profileController == nil)
    {
        [self getEmployeesInOrganization];
    }
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if(_profileController != nil)
    {
        [self getEmployeesInOrganization];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"adminProfileSegue"])
    {
        _profileController = (AdminUserProfileViewController*)segue.destinationViewController;
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
    
    if(_profileController != nil)
    {
        _profileController.userName = cell.textLabel.text;
    }
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Keys"])
    {
        _sections = [responseData valueForKey:@"Keys"];
        _rows = [responseData valueForKey:@"Users"];
        [self.tableViewOutlet reloadData];
    }
    else
    {
        [Utilities displayError:[responseData valueForKey:@"Message"]];
    }
}

-(void) handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(void) getEmployeesInOrganization
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"User/GetAllUsersInOrganization?organizationname="];
    [url appendString:[RequestManager getOrganizationName]];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
}

@end

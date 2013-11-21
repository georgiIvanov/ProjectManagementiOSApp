//
//  AdminUserProfileViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/12/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "AdminUserProfileViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "UserRole.h"

@interface AdminUserProfileViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, HttpRequestDelegate>

@end

@implementation AdminUserProfileViewController
{
    BOOL _awaitingRequest;
    NSArray* _projects;
    NSArray* _roles;
    NSInteger _currentRole;
    UIButton* _lastPMPushed;
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
    
    _projects = [[NSArray alloc] init];
    [self getAdminUserProfile];
    [self initRoles];
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
    self.rolesPicker.delegate = self;
    self.rolesPicker.dataSource = self;
    _awaitingRequest = NO;
    self.navigationItem.title = self.userName;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initRoles
{
    _roles = [[NSArray alloc] initWithObjects:
              [[UserRole alloc]initWithRole:@"Organization Owner"
                                      value:ORGANIZATION_OWNER],
              [[UserRole alloc]initWithRole:@"Organization Manager"
                                  value:ORGANIZATION_MANAGER],
              [[UserRole alloc]initWithRole:@"Senior Employee"
                                  value:SENIOR_EMPLOYEE],
              [[UserRole alloc]initWithRole:@"Employee"
                                  value:EMPLOYEE],
              [[UserRole alloc]initWithRole:@"Junior Employee"
                                  value:JUNIOR_EMPLOYEE],
              nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell.
    NSObject* project = [_projects objectAtIndex:indexPath.item];
    cell.textLabel.text = [project valueForKey:@"Name"];
    UISwitch* innerSwitch = (UISwitch*)[cell viewWithTag:1];
    UIButton* pmButton = (UIButton*)[cell viewWithTag:2];
    if([[project valueForKey:@"UserParticipatesIn"] boolValue])
    {
        [innerSwitch setOn:YES];
        pmButton.hidden = NO;
        [self setAppropriateColorForButton:pmButton project:project];
        
    }
    else
    {
        [innerSwitch setOn:NO];
    }
    return cell;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_roles count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_roles objectAtIndex:row] valueForKey:@"RoleName"];
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Projects"])
    {
        _projects = [responseData valueForKey:@"Projects"];
        [self.tableViewOutlet reloadData];
        _currentRole = [[responseData valueForKey:@"Role"] integerValue];
        [self selectAppropriatePickRow];
    }	
    else if([responseData objectForKey:@"Removed"])
    {
        
    }
    else if([responseData objectForKey:@"Assigned"])
    {
        
    }
    else if([responseData objectForKey:@"User"])
    {
        [self getAdminUserProfile];
        _lastPMPushed.enabled = YES;
    }
    _awaitingRequest = NO;
}

-(void) handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.isMovingFromParentViewController)
    {
        NSInteger rowNumber = [self.rolesPicker selectedRowInComponent:0];
        NSInteger role = [[[_roles objectAtIndex:rowNumber] valueForKey:@"Value"] integerValue];
        if(role != _currentRole)
        {
            [self changeUserRole:role];
        }
    }
}

-(void)selectAppropriatePickRow{
    for (NSInteger i = 0; i < [_roles count]; i++) {
        if([[[_roles objectAtIndex:i] valueForKey:@"Value"] integerValue] == _currentRole)
        {
            [self.rolesPicker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

-(void)setAppropriateColorForButton:(UIButton*) button project:(NSObject*)project
{
    if([[project valueForKey:@"Role"] integerValue] != ProjectManager)
    {
        [button setTitleColor:[UIColor colorWithRed:0.67 green:0.84 blue:0.88 alpha:1.0] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:[UIColor colorWithRed:0.08 green:0.72 blue:0.89 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (IBAction)switchPressed:(id)sender {
    
    if(_awaitingRequest)
    {
        return;
    }
    _awaitingRequest = YES;
    UISwitch* switchControl = (UISwitch*)sender;
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    

    [self changeUserParticipation:switchControl.on projectName: cell.textLabel.text];
    UIButton* pmButton = (UIButton*)[cell viewWithTag:2];
    if(switchControl.on)
    {
        
        pmButton.hidden = NO;
        [pmButton setTitleColor:[UIColor colorWithRed:0.67 green:0.84 blue:0.88 alpha:1.0] forState:UIControlStateNormal];

    }
    else
    {
        pmButton.hidden = YES;
    }

}

- (IBAction)makePMPressed:(id)sender
{
    if(_awaitingRequest)
    {
        return;
    }
    _awaitingRequest = YES;
    UIButton* button = (UIButton*)sender;
    _lastPMPushed = button;
    _lastPMPushed.enabled = NO;
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    
    NSIndexPath* indexPath = [self.tableViewOutlet indexPathForCell:cell];
    
    NSObject* project = [_projects objectAtIndex:indexPath.item];
    Role role = [[project valueForKey:@"Role"]integerValue];
    
    BOOL makeManager = role == ProjectManager ? NO : YES;
    NSString* strMakeManager = [[NSString alloc] initWithFormat:@"%@", makeManager ? @"true" : @"false"];
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"User/SetProjectManager"];
    
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.userName, @"Username",
                              [RequestManager getOrganizationName], @"OrganizationName",
                              [project valueForKey:@"Name"],@"ProjectName",
                              strMakeManager, @"SetAsManager",
                              nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

-(void) changeUserRole:(NSInteger)role
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"User/ChangeUserRole"];
    
    NSString* strRole = [[NSString alloc] initWithFormat:@"%d", role];
    
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.userName, @"Username",
                              [RequestManager getOrganizationName], @"OrganizationName",
                              strRole, @"UserRole",
                              nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
}

-(void) changeUserParticipation:(BOOL)participates projectName:(NSString*)projectName
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    if(participates)
    {
        [url appendString:@"Project/PartInProject"];
    }
    else
    {
        [url appendString:@"Project/RemoveFromProject"];
    }
    
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.userName, @"Username",
                              [RequestManager getOrganizationName], @"OrganizationName",
                              projectName, @"ProjectName",
                              nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];}

-(void) getAdminUserProfile
{
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.userName, @"Username",
                              [RequestManager getOrganizationName], @"OrganizationName",
                              nil];
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"User/UserAdminProfile"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}
@end

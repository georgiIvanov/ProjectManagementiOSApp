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

@interface AdminUserProfileViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation AdminUserProfileViewController
{
    NSArray* _projects;
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
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
    
    self.navigationItem.title = self.userName;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if([[project valueForKey:@"UserParticipatesIn"] boolValue])
    {
        [innerSwitch setOn:YES];
    }
    else
    {
        [innerSwitch setOn:NO];
    }
    return cell;
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Projects"])
    {
        _projects = [responseData valueForKey:@"Projects"];
        [self.tableViewOutlet reloadData];
    }
    else if([responseData objectForKey:@"Removed"])
    {
        
    }
    else if([responseData objectForKey:@"Assigned"])
    {
        
    }
    else
    {
        [Utilities displayError:[responseData valueForKey:@"Message"]];
    }
}

-(void) handleError:(NSError *)error
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)switchPressed:(id)sender {
    
    UISwitch* switchControl = (UISwitch*)sender;
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    

    [self changeUserParticipation:switchControl.on projectName: cell.textLabel.text];


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

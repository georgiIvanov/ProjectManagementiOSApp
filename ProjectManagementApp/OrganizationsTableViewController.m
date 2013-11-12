//
//  OrganizationsTableViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/4/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "OrganizationsTableViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "InOrganizationViewController.h"

@interface OrganizationsTableViewController () <HttpRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation OrganizationsTableViewController
{
    NSMutableArray* _objects;
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
    _objects = [[NSMutableArray alloc] init];
    [self.tableViewOut setDelegate:self];
    [RequestManager setRole: UNDETERMINED_ROLE];
    
    //self.navigation.backBarButtonItem.title = @"Logout";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getOrganizations];
    [self checkForInvitations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [[_objects objectAtIndex:indexPath.row] valueForKey:@"Name"];
    
    return cell;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSObject* org = [_objects objectAtIndex:indexPath.item];
    NSString* name = [org valueForKey:@"Name"];
    [RequestManager setOrganizationName: name];
    Role r = (Role)[[org valueForKey:@"Role"] integerValue];
    [RequestManager setRole:r];

    [self callSegue:r];
}


-(void)getOrganizations
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Organization/GetInvolvedOrganizations"];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
}

-(void)checkForInvitations
{
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Invitations/CheckForInvitations"];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
   
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData valueForKey:@"Organizations"])
    {
        _objects = [responseData objectForKey:@"Organizations"];
        [self.tableViewOut reloadData];
      
        
    }
    else if([responseData valueForKey:@"InvitationsCount"])
    {
        NSMutableString* title = [[NSMutableString alloc]
                                  initWithString:[responseData
                                  valueForKey:@"InvitationsCount"]];
        
        if([title compare:@"0"] != NSOrderedSame)
        {
            [title appendString:@" New Invitations"];
            [self.invitationsBtn
            setTitle:title
             forState:UIControlStateNormal];
            [self.invitationsBtn setEnabled:YES];
        }
        else
        {
            [self.invitationsBtn
             setTitle:@"No Invitations"
             forState:UIControlStateNormal];
            [self.invitationsBtn setEnabled:NO];
        }
    }
    else
    {
        [Utilities displayError:[responseData description]];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Navigation
-(void) callSegue:(Role)role
{
    if(role >= 30)
    {
        [self performSegueWithIdentifier:@"InOrganizationSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"userProfileSegue" sender:self];
    }
}
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)logout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

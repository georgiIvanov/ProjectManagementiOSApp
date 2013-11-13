//
//  ManageInvitationsViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/7/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "ManageInvitationsViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface ManageInvitationsViewController () <HttpRequestDelegate, UIAlertViewDelegate>

@end

@implementation ManageInvitationsViewController
{
    NSMutableArray *_invitations;
    NSInteger _invitationIndex;
}

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
    _invitations = [[NSMutableArray alloc] init];
    _invitationIndex = -1;
    [self getInvitations];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [_invitations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [[_invitations objectAtIndex:indexPath.item] valueForKey:@"OrganizationName"];
    
    return cell;
}

#pragma mark - Invitation Actions

-(void)getInvitations
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Invitations/SeeInvitations"];
    
    [RequestManager createAuthenticatedGet:url delegate:self];

}

-(void)rejectInvitation:(NSUInteger)index
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Invitations/RejectInvitation"];

    NSObject* invitation = [_invitations objectAtIndex:index];
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              [invitation valueForKey:@"Id"], @"Id",
                              [invitation valueForKey:@"OrganizationName"], @"OrganizationName"
                              , nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
//    [RequestManager createAuthenticatedGet:url delegate:self];
}

-(void)acceptInvitation
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Invitations/AcceptInvitation"];
    
    NSObject* invitation = [_invitations objectAtIndex:_invitationIndex];
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              [invitation valueForKey:@"Id"], @"Id",
                              [invitation valueForKey:@"OrganizationName"], @"OrganizationName"
                              , nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
    NSIndexPath *path = [NSIndexPath indexPathForRow:_invitationIndex inSection:0];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    [_invitations removeObjectAtIndex:_invitationIndex];
    [self.tableView endUpdates];
}

-(void) handleSuccessWithMutableDictionary:(NSMutableDictionary *)responseData
{
    
    
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Invitations"])
    {
        NSMutableDictionary *mutableDict =
        [responseData mutableCopy];
        _invitations = [mutableDict mutableArrayValueForKey:@"Invitations"];
        //_invitations = [responseData mutableArrayValueForKey:@"Invitations"];
        [self.tableView reloadData];
    }
    else if([responseData objectForKey:@"Accepted"])
    {
        
    }
}

-(void) handleError:(NSError *)error
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView beginUpdates];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self rejectInvitation:indexPath.item];
        [_invitations removeObjectAtIndex:indexPath.item];
        [self.tableView endUpdates];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_invitations.count == 0)
    {
        return;
    }
    
    _invitationIndex = indexPath.item;
    NSObject* invitation = [_invitations objectAtIndex:_invitationIndex];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invitation From"
                                                    message: [invitation valueForKey:@"OrganizationName"]
                                                   delegate:self
                                          cancelButtonTitle:@"Accept"
                                          otherButtonTitles:@"Cancel", nil];
    
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self acceptInvitation];
    }
    _invitationIndex = -1;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

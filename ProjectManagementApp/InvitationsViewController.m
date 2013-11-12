//
//  InvitationsViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/6/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "InvitationsViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
#import <AddressBook/AddressBook.h>


@interface InvitationsViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation InvitationsViewController
{
    NSMutableArray* _filteredContacts;
    ABAddressBookRef _addressBook;
    NSArray *_people;
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
    _filteredContacts = [[NSMutableArray alloc] init];
    [self.tableView setDelegate:self];
    
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    self.searchBar.delegate = self;
    
    CFErrorRef *error = nil;
//    BOOL granted;
    _addressBook = ABAddressBookCreateWithOptions(nil, error);
    
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error){
    
        if(granted){
             _people = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(_addressBook);
        }
        
    });
    
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
     return [_filteredContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [_filteredContacts objectAtIndex:indexPath.row]];
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length >= 2 && _people != nil)
    {
        //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mockSearch:) userInfo:searchText repeats:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate* predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary* bindings) {
                ABMultiValueRef emails = ABRecordCopyValue( (__bridge ABRecordRef)record, kABPersonEmailProperty);
                BOOL result = NO;
                
                for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                    NSString* email = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(emails, i);
                    if ([email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        result = YES;
                        [_filteredContacts addObject:email];
                        break;
                    }
                }
                
                CFRelease(emails);
                return result;
            }];
            [_filteredContacts removeAllObjects];
            [_people filteredArrayUsingPredicate:predicate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
    else
    {
        [_filteredContacts removeAllObjects];
        [self.tableView reloadData];
    }
    
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    if(_filteredContacts == nil)
    {
        return;
    }
    [RequestManager getOrganizationName];

    self.searchBar.text = [_filteredContacts objectAtIndex:indexPath.item];
    //    InOrganizationViewController* controller = [[InOrganizationViewController alloc] init];
    //    [controller setTitle:name];
    //    [self.navigationController pushViewController:controller animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)sendInvitation:(id)sender {
    if(self.searchBar.text.length < 3)
    {
        [Utilities displayError:@"Invalid username"];
        return;
    }
    
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              self.searchBar.text, @"InvitedUser",
                              [RequestManager getOrganizationName], @"OrganizationName", nil];
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Invitations/InviteToOrganization"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

    
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData valueForKey:@"Success"])
    {
        [Utilities displayAlert:@"Success!" message:@"Invitation sent."];
        self.searchBar.text = @"";
    }
    else if([responseData valueForKey:@"Message"])
    {
        [Utilities displayError:[responseData valueForKey:@"Message"]];
    }
}

-(void) handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}
@end

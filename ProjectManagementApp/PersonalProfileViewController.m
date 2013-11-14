//
//  PersonalProfileViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/14/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

#import "InProjectViewController.h"

@interface PersonalProfileViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation PersonalProfileViewController
{
    NSArray* _projects;
    InProjectViewController* _projectController;

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
    _projects = [[NSArray alloc]init];
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
    [self getProjects];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"inProfileSegue"])
    {
        _projectController = (InProjectViewController*)segue.destinationViewController;
    }
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
    
    cell.textLabel.text = [_projects objectAtIndex:indexPath.item];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    
    if(_projectController != nil)
    {
        _projectController.projectName = cell.textLabel.text;
    }
}


-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Projects"])
    {
        _projects = [responseData valueForKey:@"Projects"];
        [self.tableViewOutlet reloadData];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(void)getProjects
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];

    [url appendString:@"User/UserProfile"];
    NSDictionary* sentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              
                              [RequestManager getOrganizationName], @"OrganizationName",
                              
                              nil];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
}

@end

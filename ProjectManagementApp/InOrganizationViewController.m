//
//  InOrganizationViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/5/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "InOrganizationViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface InOrganizationViewController () <HttpRequestDelegate>

@end

@implementation InOrganizationViewController
{
    BOOL _reloadInformation;
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
    [self recentEvents];
    [self getInformation];
    _reloadInformation = NO;
    self.navigationItem.title = [RequestManager getOrganizationName];
    
    [self initViews];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!_reloadInformation)
    {
        _reloadInformation = YES;
        return;
    }
    
    [self recentEvents];
    [self getInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData valueForKey:@"Employees"])
    {
        self.employeesInfoLbl.text = [responseData valueForKey:@"Employees"];
        self.projectsInfoLbl.text = [responseData valueForKey:@"Projects"];
    }
    else if([responseData valueForKey:@"Events"])
    {
        self.eventsText.text =
        [responseData valueForKey:@"Events"];
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


- (IBAction)goToProjects:(id)sender {
    [Utilities displayError:@"projs"];
}

- (IBAction)goToEmployees:(id)sender {
    
}

-(void) recentEvents
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Organization/RecentEvents?organizationname="];
    [url appendString:[RequestManager getOrganizationName]];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
}

-(void) getInformation
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Organization/GetFullInfo?organizationname="];
    [url appendString:[RequestManager getOrganizationName]];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
}

-(void)initViews
{
    UIColor* color =[UIColor colorWithRed:0/255.0f green:128/255.0f blue:222/255.0f alpha:1.0f];
    float radius = 6.0f, border = 1.0f;
    [self.projectsView.layer setCornerRadius:radius];
    [self.projectsView.layer setBorderWidth:border];
    [self.projectsView.layer setBorderColor: color.CGColor];
    [self.employeesView.layer setCornerRadius:radius];
    [self.employeesView.layer setBorderWidth:border];
    [self.employeesView.layer setBorderColor: color.CGColor];
    [self.summaryView.layer setCornerRadius:radius];
    [self.summaryView.layer setBorderWidth:border];
    [self.summaryView.layer setBorderColor: color.CGColor];
}


@end

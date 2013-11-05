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

@interface InOrganizationViewController () <ViewControllerDelegate>

@end

@implementation InOrganizationViewController

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
    self.navigationItem.title = [RequestManager getOrganizationName];
    
    [self initViews];	
    
//    int height =self.scrollView.frame.size.height -
//    self.navItem.frame.size.height;
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, height);
//    
//    // Generate content for our scroll view using the frame height and width as the reference point
//    
//    for (int i =0; i< 2; i++) {
//        int left = ((self.scrollView.frame.size.width)*i)+20;
//        UIView *views = [[UIView alloc]
//                         initWithFrame:CGRectMake(left, 10,(self.scrollView.frame.size.width)-40, self.scrollView.frame.size.height-60)];
//        
//        views.backgroundColor=[UIColor yellowColor];
//        [views setTag:i];
//        [self.scrollView addSubview:views];
//
//    }
    
	// Do any additional setup after loading the view.
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
    [Utilities displayError:@"emps"];
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

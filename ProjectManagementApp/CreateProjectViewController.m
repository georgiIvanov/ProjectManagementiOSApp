//
//  CreateProjectViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/8/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "CreateProjectViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface CreateProjectViewController () <HttpRequestDelegate>

@end

@implementation CreateProjectViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)submitProject:(id)sender {
    
    if(![self fieldsAreValid])
    {
        return;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString* finishDateString = [formatter stringFromDate:self.projectFinishDate.date];
//    self.projectFinishDate.date
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              self.projectNameTxt.text, @"Name",
                              self.projectDescriptionTxt.text, @"Description",
                              finishDateString, @"FinishDate",
                              [RequestManager getOrganizationName], @"OrganizationName",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    //todo
    [url appendString:@"Project/CreateProject"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
    
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Created"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Utilities displayError:[responseData valueForKey:@"Message"]];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(BOOL) fieldsAreValid
{
    
    return YES;
}
@end

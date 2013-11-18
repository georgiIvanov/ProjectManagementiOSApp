//
//  TaskCreateViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/18/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "TaskCreateViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface TaskCreateViewController () <HttpRequestDelegate>

@end

@implementation TaskCreateViewController

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

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Posted"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

- (IBAction)submitTask:(id)sender {
    if(![self fieldsAreValid])
    {
        return;
    }
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              self.taskDescription.text, @"TaskDescription",
                              self.taskTitle.text, @"TaskName",
                              [RequestManager getProjectName], @"ProjectName",
                              [RequestManager getOrganizationName],
                              @"OrganizationName",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Task/CreateTask"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

-(BOOL)fieldsAreValid
{
    if(self.taskTitle.text.length < 1 || self.taskTitle.text.length > 20)
    {
        [Utilities displayError:@"Task title length must be between 1 and 20 symbols"];
        return NO;
    }
    
    if(self.taskDescription.text.length > 100)
    {
        [Utilities displayError:@"Task description length must be less than 100 symbols"];
        return NO;
    }
    
    return YES;
}
@end

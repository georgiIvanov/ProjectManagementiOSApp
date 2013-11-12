//
//  CreateOrganizationViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/4/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "CreateOrganizationViewController.h"
#import "RequestManager.h"
#import "Utilities.h"
#import "Constants.h"

@interface CreateOrganizationViewController () <HttpRequestDelegate>

@end

@implementation CreateOrganizationViewController

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

- (IBAction)selectionChanged:(id)sender {
    if(self.segmentCtrl.selectedSegmentIndex == 1)
    {
        self.detailsView.hidden = false;
        self.requiredView.hidden = true;
    }
    else
    {
        self.detailsView.hidden = true;
        self.requiredView.hidden = false;
    }
}
- (IBAction)submitOrganization:(id)sender {
    if(![self fieldsAreValid])
    {
        return;
    }
    
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              self.txtOrganizationName.text, @"Name",
                              self.txtDescription.text, @"Description",
                              self.txtOrganizationVision.text, @"Vision",
                              self.txtMotto.text, @"Motto",nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Organization/CreateOrganization"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData valueForKey:@"Name" ] != nil)
    {
        [Utilities displayAlert:@"Success" message:@"Organization is created"];
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
    if(self.txtOrganizationName.text.length < 1 ||
       self.txtOrganizationName.text.length > 50)
    {
        [Utilities displayError:@"Organization name is mandatory and has to be between 1 and 50 characters"];
        return false;
    }
    
    if([self.txtOrganizationVision.text length] > 150)
    {
        [Utilities displayError:@"Organization vision has to be below 150 characters"];
        return false;
    }
    
    if([self.txtMotto.text length] > 50)
    {
        [Utilities displayError:@"Organization motto has to be below 50 characters"];
        return false;
    }
    
    if([self.txtDescription.text length] > 300)
    {
        [Utilities displayError:@"Organization motto has to be below 50 characters"];
        return false;
    }
    
    
//    if(![self validateEmail:self.emailTxt.text])
//    {
//        [Utilities displayError:@"Invalid email address."];
//        return NO;
//    }

    
    return  true;
}
@end

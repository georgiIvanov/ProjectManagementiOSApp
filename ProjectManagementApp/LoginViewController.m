//
//  LoginViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/2/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "RequestManager.h"
#import "Utilities.h"
#import <CommonCrypto/CommonDigest.h>

@interface LoginViewController () <UITextFieldDelegate, HttpRequestDelegate>

@end

@implementation LoginViewController

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
    
    self.usernameTxt.delegate = self;
    self.passwordTxt.delegate = self;
    [self.activityIndicator stopAnimating];
    //self.usernameTxt.text = @DOMAIN_ROOT;
	self.usernameTxt.text= @"tata";
    self.passwordTxt.text=@"tata";
    [self loginUser:self.btnLogin ];
    
    [RequestManager setAuthKey:@""];
    [RequestManager setOrganizationName:@""];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.usernameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    return YES;
}

-(void)error:(NSString*)message
{
    self.passwordTxt.text = @"";
    
}

- (IBAction)registerUser:(id)sender {
//    self.usernameTxt.text = @DOMAIN_ROOT;
}

- (IBAction)loginUser:(id)sender {
    
    NSString* userNameOrEmail;
    if([self.usernameTxt.text rangeOfString:@"@"].location == NSNotFound)
    {
        userNameOrEmail = @"Username";
    }
    else
    {
        userNameOrEmail = @"Email";
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    NSData *stringBytes = [self.passwordTxt.text dataUsingEncoding: NSUTF8StringEncoding];
    if (!CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has NOT been calculated and stored in 'digest'. */
        [Utilities displayError:@"Error with password, please try again."];
        return;
    }
    
//    NSData* data = [[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];

    NSString* data = [[[[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH] description]
                        stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* hash = [data substringWithRange:NSMakeRange(1, data.length - 2)];
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:self.usernameTxt.text, userNameOrEmail,
                            hash, @"PasswordSecret", nil];
//    NSData* sendingData = [NSData alloc]
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Account/Login"];
    
    [self.activityIndicator startAnimating];
    
    [RequestManager createRequest:url httpMethod:@"PUT" sentData:sentData delegate:self];
//    [loading removeFromSuperview];
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData valueForKey:@"AuthKey"] != nil )
    {
        [RequestManager setAuthKey:[responseData valueForKey:@"AuthKey"]];
        [RequestManager setLastDate:[responseData valueForKey:@"LastLogged"]];
        [self performSegueWithIdentifier:@"organizationsSegue" sender:self];
    }
    
    [self.activityIndicator stopAnimating];

}

-(void) handleError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message: [error description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end

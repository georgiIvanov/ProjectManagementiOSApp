//
//  RegisterViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/3/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "RequestManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface RegisterViewController () <HttpRequestDelegate>

@end

@implementation RegisterViewController

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
    [self.activityIndicator stopAnimating];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitRegistration:(id)sender {
    if(![self fieldsAreValid])
    {
        return;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    NSData *stringBytes = [self.passwordTxt.text dataUsingEncoding: NSUTF8StringEncoding];
    if (!CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has NOT been calculated and stored in 'digest'. */
        [Utilities displayError:@"Error with password, please try again."];
        return;
    }

    NSString* data = [[[[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH] description]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* hash = [data substringWithRange:NSMakeRange(1, data.length - 2)];
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              self.usernameTxt.text, @"Username",
                              self.emailTxt.text, @"Email",
                              hash, @"PasswordSecret", nil];
    //    NSData* sendingData = [NSData alloc]
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Account/Register"];
    
    [self.activityIndicator startAnimating];
    
    [RequestManager createRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

    
}

-(void) handleSuccess:(NSDictionary *)responseData
{
    [self.activityIndicator stopAnimating];
    if([responseData objectForKey:@"AuthKey"] != nil )
    {
        [RequestManager setAuthKey:[responseData valueForKey:@"AuthKey"]];
        [RequestManager setLastDate:[responseData valueForKey:@"LastLogged"]];
        
    }
    else
    {
        [Utilities displayError:@"Error with request"];
    }
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

-(BOOL)fieldsAreValid
{
    if(self.usernameTxt.text.length < 3 || self.usernameTxt.text.length > 20)
    {
//        [self displayError:@"Username must be between 3 and 20 characters."];
        [Utilities displayError:@"Username must be between 3 and 20 characters."];
        return NO;
    }
    
    if(![self validateEmail:self.emailTxt.text])
    {
        [Utilities displayError:@"Invalid email address."];
        return NO;
    }
    
    NSComparisonResult result = [self.passwordTxt.text compare:self.passwordConfirmTxt.text];
    
    
    if(result != NSOrderedSame)
    {
        [Utilities displayError:@"Passwords do not match."];
        return NO;
    }
    
    return YES;
}

//-(void)displayError:(NSString*)errorMsg
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                    message: errorMsg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    
//    [alert show];
//}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}





@end

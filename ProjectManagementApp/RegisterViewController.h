//
//  RegisterViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/3/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;

@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTxt;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)submitRegistration:(id)sender;

@end

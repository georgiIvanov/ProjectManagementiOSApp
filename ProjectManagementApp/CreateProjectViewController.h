//
//  CreateProjectViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/8/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectNameTxt;
@property (weak, nonatomic) IBOutlet UITextView *projectDescriptionTxt;
@property (weak, nonatomic) IBOutlet UIDatePicker *projectFinishDate;
- (IBAction)submitProject:(id)sender;

@end

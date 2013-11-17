//
//  TaskCreateViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/18/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCreateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
- (IBAction)submitTask:(id)sender;

@end

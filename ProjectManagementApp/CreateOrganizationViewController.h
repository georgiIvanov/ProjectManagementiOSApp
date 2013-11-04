//
//  CreateOrganizationViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/4/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrganizationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
- (IBAction)selectionChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtOrganizationName;
@property (weak, nonatomic) IBOutlet UITextField *txtOrganizationVision;
@property (weak, nonatomic) IBOutlet UITextField *txtMotto;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIView *requiredView;
- (IBAction)submitOrganization:(id)sender;

@end

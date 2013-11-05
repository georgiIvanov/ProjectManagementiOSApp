//
//  InOrganizationViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/5/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InOrganizationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *projectsView;
@property (weak, nonatomic) IBOutlet UIView *employeesView;
@property (weak, nonatomic) IBOutlet UIView *summaryView;

@property (weak, nonatomic) IBOutlet UILabel *projectsInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *employeesInfoLbl;
@property (weak, nonatomic) IBOutlet UITextView *eventsText;



- (IBAction)goToProjects:(id)sender;
- (IBAction)goToEmployees:(id)sender;


@end

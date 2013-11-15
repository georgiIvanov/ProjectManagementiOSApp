//
//  IssueViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/14/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueViewController : UIViewController
@property (weak, nonatomic) NSString* projectName;
@property (weak, nonatomic) NSString* issueId;
@property (weak, nonatomic) IBOutlet UITextField *issueTitle;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (nonatomic) BOOL IsBeingOpened;
@end

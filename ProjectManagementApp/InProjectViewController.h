//
//  InProjectViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/14/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InProjectViewController : UIViewController

@property (weak, nonatomic) NSString* projectName;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
- (IBAction)openIssueAction:(id)sender;
- (IBAction)createNoteAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *assignReportBtn;
@property (weak, nonatomic) IBOutlet UIButton *createTaskBtn;
@property (weak, nonatomic) IBOutlet UIButton *createNoteBtn;


@end

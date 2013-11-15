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

@end

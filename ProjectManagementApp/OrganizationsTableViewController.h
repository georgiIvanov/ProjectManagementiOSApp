//
//  OrganizationsTableViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/4/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationsTableViewController : UITableViewController
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;

@end

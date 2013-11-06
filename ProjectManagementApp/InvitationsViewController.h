//
//  InvitationsViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/6/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sendInvitation:(id)sender;

@end

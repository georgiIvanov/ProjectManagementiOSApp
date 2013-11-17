//
//  AdminUserProfileViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/12/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminUserProfileViewController : UIViewController

@property(weak, nonatomic) NSString* userName;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
- (IBAction)switchPressed:(id)sender;
- (IBAction)makePMPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *rolesPicker;


@end

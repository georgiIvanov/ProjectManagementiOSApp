//
//  ReadNoteViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/16/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) NSString* noteId;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
- (IBAction)editAction:(id)sender;


@end

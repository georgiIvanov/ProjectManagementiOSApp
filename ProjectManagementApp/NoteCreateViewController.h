//
//  NoteCreateViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/16/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCreateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *noteTitleText;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
- (IBAction)submitNoteAction:(id)sender;

@end

//
//  LocalNoteViewController.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/20/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNoteViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitIssueBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitNoteBtn;
@property (weak, nonatomic) IBOutlet UITextField *localNoteTitle;
@property (weak, nonatomic) IBOutlet UITextView *localNoteText;
@property (weak, nonatomic) IBOutlet UIPickerView *savedLocalNotes;
- (IBAction)submitIssueAction:(id)sender;
- (IBAction)submitNoteAction:(id)sender;
- (IBAction)saveNoteAction:(id)sender;
- (IBAction)deleteAction:(id)sender;


@end

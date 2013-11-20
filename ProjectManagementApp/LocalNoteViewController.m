//
//  LocalNoteViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/20/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "LocalNoteViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "LocalNote.h"

@interface LocalNoteViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation LocalNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [AppDelegate getContext];
    self.savedLocalNotes.delegate = self;
    self.savedLocalNotes.dataSource = self;
    
    	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    if([Utilities checkIfInProject])
    {
        self.submitIssueBtn.hidden = NO;
        if([RequestManager getRole] >= ProjectManager)
            self.submitNoteBtn.hidden = NO;
        self.localNoteText.editable = NO;
        self.localNoteTitle.enabled = NO;
        self.saveBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;//[_roles count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"lala";//[[_roles objectAtIndex:row] valueForKey:@"RoleName"];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)submitIssueAction:(id)sender {
}

- (IBAction)submitNoteAction:(id)sender {
}
@end

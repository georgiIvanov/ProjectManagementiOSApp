//
//  ReadNoteViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/16/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "ReadNoteViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface ReadNoteViewController () <HttpRequestDelegate>

@end

@implementation ReadNoteViewController
{
    BOOL _isEditing;
}
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
    [self getNote];
    _isEditing = NO;
    [self checkPermissions];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Note"])
    {
        NSObject* note = [responseData valueForKey:@"Note"];
        self.noteTextView.text = [note valueForKey:@"Text"];
        self.noteTitle.text = [note valueForKey:@"Title"];
        
    }
}

-(void) handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(void)getNote
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Note/GetNote?noteId="];
    [url appendString:self.noteId];
    
    [RequestManager createAuthenticatedGet:url delegate:self];
}

- (IBAction)editAction:(id)sender {
    _isEditing = !_isEditing;
    if(_isEditing)
    {
        self.editBtn.title = @"Save";
        self.noteTextView.editable = YES;
        
    }
    else
    {
        self.editBtn.title = @"Edit";
        self.noteTextView.editable = NO;
        [self.noteTextView resignFirstResponder];
        NSDictionary* sentData = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  self.noteTextView.text, @"Text",
                                  // self.noteTitle.text, @"Title",
                                  self.noteId, @"Id",
                                  nil];
        
        NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
        
        [url appendString:@"Note/EditNote"];
        
        [RequestManager createAuthenticatedRequest:url httpMethod:@"PUT" sentData:sentData delegate:self];

    }
}

-(void)checkPermissions
{
    if([RequestManager getRole] >= SENIOR_EMPLOYEE)
    {
        self.editBtn.enabled = YES;
    }
}
@end

//
//  NoteCreateViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/16/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "NoteCreateViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

@interface NoteCreateViewController () <HttpRequestDelegate>

@end

@implementation NoteCreateViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Posted"])
   {
       [self.navigationController popViewControllerAnimated:YES];
   }
}

-(void) handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

- (IBAction)submitNoteAction:(id)sender {
    if(![self validateFields])
    {
        return;
    }
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              self.noteTextView.text, @"Text",
                              self.noteTitleText.text, @"Title",
                              [RequestManager getProjectName], @"ProjectName",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Note/PostNote"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

-(BOOL)validateFields
{
    if(self.noteTitleText.text.length < 3)
    {
        [Utilities displayError:@"Title must be longer than 3 characters."];
        return NO;
    }
    return YES;
}
@end

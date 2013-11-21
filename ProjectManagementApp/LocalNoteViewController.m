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

@interface LocalNoteViewController () <UIPickerViewDataSource, UIPickerViewDelegate, HttpRequestDelegate>

@end

@implementation LocalNoteViewController
{
    LocalNote* _selectedNote;
}

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    [self reloadControls];
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
        self.deleteBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSFetchedResultsController*)fetchedResultsController
{
    if(_fetchedResultsController != nil)
    {
        return  _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"LocalNote" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger number = [[self.fetchedResultsController sections] count];
    return number;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    id<NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:component];
    NSInteger number =[secInfo numberOfObjects];
    return number;
    //return 3;//[_roles count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LocalNote* localNote = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    return localNote.title;
    //return @"lala";//[[_roles objectAtIndex:row] valueForKey:@"RoleName"];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectedNote = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    self.localNoteTitle.text = _selectedNote.title;
    self.localNoteText.text = _selectedNote.content;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Posted"])
    {
        [self deleteAction:self];
    }
}

- (IBAction)submitIssueAction:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dateNow = [[NSDate alloc] init];
    NSString* dateString = [formatter stringFromDate:dateNow];
    
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              _selectedNote.title, @"Title",
                              [RequestManager getProjectName], @"ProjectName",
                              _selectedNote.content, @"Text",
                              dateString, @"DatePosted",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Issue/PostIssue"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

- (IBAction)submitNoteAction:(id)sender {
    NSDictionary* sentData = [[NSDictionary alloc]
                              initWithObjectsAndKeys:
                              _selectedNote.content, @"Text",
                              _selectedNote.title, @"Title",
                              [RequestManager getProjectName], @"ProjectName",
                              nil];
    
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    
    [url appendString:@"Note/PostNote"];
    
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

}

- (IBAction)saveNoteAction:(id)sender {
    if(![self checkFields])
    {
        return;
    }
    
    if(_selectedNote)
    {
        _selectedNote.title =self.localNoteTitle.text;
        _selectedNote.content = self.localNoteText.text;
    }
    else
    {
        LocalNote* localNote = (LocalNote*)[NSEntityDescription insertNewObjectForEntityForName:@"LocalNote" inManagedObjectContext:self.managedObjectContext];
        localNote.title = self.localNoteTitle.text;
        localNote.content = self.localNoteText.text;

    }
    NSError* error = nil;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Error! %@", error);
    }
    
    [self reloadControls];
}

- (IBAction)deleteAction:(id)sender {
    if(_selectedNote == nil)
    {
        return;
    }
    [self.managedObjectContext deleteObject:_selectedNote];
    [self.managedObjectContext save:nil];
    [self reloadControls];
}

-(void)reloadControls
{
    NSError* error = nil;
    if(![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Error %@", error);
        abort();
    }
    self.localNoteText.text = @"";
    self.localNoteTitle.text = @"";
    [self.savedLocalNotes reloadAllComponents];
}

-(BOOL)checkFields
{
    if(self.localNoteTitle.text.length < 3)
    {
        [Utilities displayError:@"Title length must be at least 3 symbols"];
        return NO;
    }
    
    
    
    return YES;
}
@end

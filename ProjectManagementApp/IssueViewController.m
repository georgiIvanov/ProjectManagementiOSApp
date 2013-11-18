//
//  IssueViewController.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/14/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "IssueViewController.h"
#import "RequestManager.h"
#import "Constants.h"
#import "Utilities.h"

#import "Entry.h"

@interface IssueViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate, UITextViewDelegate>

@end

@implementation IssueViewController
{
    NSMutableArray* _entries;
//    UITextView* _textInput;
    Entry* _writingCell;
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
    self.tableViewOutlet.delegate = self;
    self.tableViewOutlet.dataSource = self;
    if(self.IsBeingOpened)
    {
        self.issueTitle.enabled = YES;
        _entries = [self createOpenIssue];
        [self.tableViewOutlet reloadData];
    }
    else
    {
        [self getIssue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSObject* entry = [_entries objectAtIndex:indexPath.item];
    UILabel* username = (UILabel*)[cell viewWithTag:1];
    UITextView* text = (UITextView*)[cell viewWithTag:2];
    UILabel* time = (UILabel*)[cell viewWithTag:3];
    username.text = [entry valueForKey:@"Username"];
    text.text = [entry valueForKey:@"Text"];
    time.text = [entry valueForKey:@"Time"];
    
    if(indexPath.item == [_entries count] - 1)
    {
        text.editable = YES;
        text.delegate = self;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    
//    if(_projectController != nil)
//    {
//        _projectController.projectName = cell.textLabel.text;
//    }
}


-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"Posted"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([responseData objectForKey:@"Entries"])
    {
        _entries = [[NSMutableArray alloc] initWithArray:[responseData valueForKey:@"Entries"]];
        [self initWritingCell];
        [_entries addObject:_writingCell];
        if([responseData objectForKey:@"Title"])
        {
            self.issueTitle.text = [responseData valueForKey:@"Title"];
        }
        [self.tableViewOutlet reloadData];
    }
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

- (IBAction)submitAction:(id)sender {
    
    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:[NSIndexPath indexPathForItem:([_entries count] - 1) inSection:0]];
    UITextView* textView = (UITextView*)[cell viewWithTag:2];
    
    if(![self checkInput: textView])
    {
        return;
    }
    
    textView.editable = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dateNow = [[NSDate alloc] init];
    NSString* dateString = [formatter stringFromDate:dateNow];

    if(self.IsBeingOpened)
    {
        NSDictionary* sentData = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  self.issueTitle.text, @"Title",
                                  self.projectName, @"ProjectName",
                                  textView.text, @"Text",
                                  dateString, @"DatePosted",
                                  nil];
        
        NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
        
        [url appendString:@"Issue/PostIssue"];
        
        [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

    }
    else
    {
        NSDictionary* sentData = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  [RequestManager getLoginName], @"Username",
                                  textView.text, @"Text",
                                  dateString, @"Time",
                                  self.issueId, @"IssueId",
                                  nil];
        
        NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
        
        [url appendString:@"Issue/PostAnswerToIssue"];
        
        [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];

    }
}

-(void) initWritingCell
{
    _writingCell = [[Entry alloc] init];
    [_writingCell setValue:[RequestManager getLoginName] forKey:@"Username"];
    [_writingCell setValue:@"type here" forKey:@"Text"];
    [_writingCell setValue:@"" forKey:@"Time"];
}

-(NSMutableArray*) createOpenIssue
{
    [self initWritingCell];
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects:_writingCell, nil];
    return  array;
}

-(void) getIssue
{
    NSMutableString* url = [[NSMutableString alloc] initWithString:@DOMAIN_ROOT];
    [url appendString:@"Issue/GetIssue"];
    
        NSDictionary* sentData = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  self.issueId, @"IssueId",
                                  self.projectName, @"ProjectName"
                                  , nil];
    [RequestManager createAuthenticatedRequest:url httpMethod:@"POST" sentData:sentData delegate:self];
}

-(BOOL) checkInput:(UITextView*) textView
{
    if(self.IsBeingOpened)
    {
        if(self.issueTitle.text.length < 5)
        {
            [Utilities displayError:@"Issue title minimum length is 5."];
            return NO;
        }
        
    }
    
    if(textView.text.length > 300 || textView.text.length < 2)
    {
        [Utilities displayError:@"Message length must be between 2 and 300 symbols."];
        return NO;
    }

    
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([_entries count] > 3)
    {
        CGPoint point = self.tableViewOutlet.contentOffset;
        CGFloat offset = 250;
        point.y += offset;
        [self.tableViewOutlet setContentOffset:point animated:YES];

    }
}

@end


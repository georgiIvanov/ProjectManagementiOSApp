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

@interface Entry : NSObject

@property (weak, nonatomic) NSString* Username;
@property (weak, nonatomic) NSString* Text;

@end

@implementation Entry

@end

@interface IssueViewController ()<UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate>

@end

@implementation IssueViewController
{
    NSArray* _entries;
    UITextView* _textInput;
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
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    UITextView* text = (UITextView*)[cell viewWithTag:2];
    label.text = [entry valueForKey:@"Username"];
    text.text = [entry valueForKey:@"Text"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableViewOutlet cellForRowAtIndexPath:indexPath];
    
//    if(_projectController != nil)
//    {
//        _projectController.projectName = cell.textLabel.text;
//    }
}


-(void)handleSuccess:(NSDictionary *)responseData
{
    
}

-(void)handleError:(NSError *)error
{
    [Utilities displayError:[error description]];
}

- (IBAction)submitAction:(id)sender {
}

-(NSArray*) createOpenIssue
{
//    NSDictionary* openCell = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             [RequestManager getLoginName] , @"Username",
//                              @"", @"Text",
//                              nil];
    Entry* openCell = [[Entry alloc] init];
    [openCell setValue:[RequestManager getLoginName] forKey:@"Username"];
    [openCell setValue:@"type here" forKey:@"Text"];
    
    NSArray* array = [[NSArray alloc] initWithObjects:openCell, nil];
    return  array;
}

-(BOOL) checkInput
{
    if(self.IsBeingOpened)
    {
        if(self.issueTitle.text.length < 5)
        {
            [Utilities displayError:@"Issue title minimum length is 5."];
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}
@end


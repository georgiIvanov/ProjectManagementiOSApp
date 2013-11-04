//
//  Utilities.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/3/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(void)displayError:(NSString*)errorMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message: errorMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

+(void)displayAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message: message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end

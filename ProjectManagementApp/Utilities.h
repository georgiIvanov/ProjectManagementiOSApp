//
//  Utilities.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/3/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+(void)displayError:(NSString*)errorMsg;
+(void)displayAlert:(NSString*)title message:(NSString*)message;
+(BOOL)checkIfInProject;
@end

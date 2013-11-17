//
//  Role.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/17/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRole : NSObject

-(UserRole*)initWithRole:(NSString*)role value:(NSInteger)value;

@property (weak, nonatomic) NSString* RoleName;
@property (nonatomic) NSInteger Value;

@end

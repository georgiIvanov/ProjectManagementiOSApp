//
//  Role.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/17/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "UserRole.h"

@implementation UserRole

-(UserRole*)initWithRole:(NSString *)role value:(NSInteger)value
{
    self = [self init];
    
    self.RoleName = role;
    self.Value = value;
    
    return  self;
}

@end

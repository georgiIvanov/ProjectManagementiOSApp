//
//  Entry.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/15/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

@property (weak, nonatomic) NSString* Username;
@property (weak, nonatomic) NSString* Text;
@property (weak, nonatomic) NSString* Time;

@end


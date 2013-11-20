//
//  LocalNote.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/20/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocalNote : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end

//
//  RequestManager.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/2/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewControllerDelegate <NSObject>

-(void)handleSuccess:(NSDictionary*)responseData;
-(void)handleError:(NSError*)error;

@end

@interface RequestManager : NSObject

+(NSString*)getAuthKey;
+(void)setAuthKey:(NSString*)authKey;
+(NSDate*) getLastDate;
+(void) setLastDate:(NSString*)dateString;
+(NSString*) getOrganizationName;
+(void) setOrganizationName:(NSString*)name;


+(void) createRequest:(NSString*)path httpMethod:(NSString*)method sentData:(NSDictionary*)dictionary
             delegate:(id<ViewControllerDelegate>)vcDelegate;
+(void) createAuthenticatedRequest:(NSString*)path httpMethod:(NSString*)method sentData:(NSDictionary*)dictionary
             delegate:(id<ViewControllerDelegate>)vcDelegate;
+(void) createAuthenticatedGet:(NSString*)path delegate:(id<ViewControllerDelegate>)vcDelegate;

@end

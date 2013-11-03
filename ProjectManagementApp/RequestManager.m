//
//  RequestManager.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/2/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "RequestManager.h"

NSString* _authKey;
NSDate* _dateLastLogged;


@implementation RequestManager
{
}
+(void) setLastDate:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[formatter setDateFormat:@"MM/dd/yyyy HH:mm a"];
    _dateLastLogged = [formatter dateFromString:dateString];
}
+(NSDate*) getLastDate
{
    return _dateLastLogged;
}
+(NSString*)getAuthKey
{
    return _authKey;
}
+(void)setAuthKey:(NSString*)authKey
{
    _authKey = authKey;
}

+(void) createRequest:(NSString *)path httpMethod:(NSString*)method sentData:(NSDictionary *)dictionary
             delegate:(id<ViewControllerDelegate>)vcDelegate
            
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    //req.HTTPMethod = method;
    [req setHTTPMethod:method];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:dictionary forKey:@"Username"];
//    [archiver encodeObject:dictionary forKey:@"PasswordSecret"];
//    [archiver finishEncoding];
    
    /** data is ready now, and you can use it **/
    
    [req setHTTPBody: data ];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    synchronous request
//    NSData* responceData = [NSURLConnection sendSynchronousRequest:req returningResponse:&returning error:&error];
    
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc]init] completionHandler:
     ^(NSURLResponse *resp, NSData *responseData, NSError *error){
         NSDictionary* respDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 [vcDelegate handleSuccess:respDictionary];
             }
             else
             {
                 [vcDelegate handleError:error];
             }
         });
    }];
}

@end

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
NSString* _organizationName;
Role _userRole;


@implementation RequestManager

#pragma mark Requests

+(void) createRequest:(NSString *)path httpMethod:(NSString*)method sentData:(NSDictionary *)dictionary
             delegate:(id<HttpRequestDelegate>)vcDelegate
            
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    
    [req setHTTPMethod:method];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [req setHTTPBody: data ];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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

+(void) createAuthenticatedRequest:(NSString*)path httpMethod:(NSString*)method sentData:(NSDictionary*)dictionary
                          delegate:(id<HttpRequestDelegate>)vcDelegate
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:method];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [req setHTTPBody: data ];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[self getAuthKey] forHTTPHeaderField:@"X-authKey"];
    
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

+(void) createAuthMutableRequest:(NSString*)path httpMethod:(NSString*)method sentData:(NSDictionary*)dictionary
                          delegate:(id<HttpRequestDelegate>)vcDelegate
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:method];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [req setHTTPBody: data ];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[self getAuthKey] forHTTPHeaderField:@"X-authKey"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc]init] completionHandler:
     ^(NSURLResponse *resp, NSData *responseData, NSError *error){
         NSMutableDictionary* respDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 [vcDelegate handleSuccessWithMutableDictionary:respDictionary];
             }
             else
             {
                 [vcDelegate handleError:error];
             }
         });
     }];
    
}

+(void) createAuthenticatedGet:(NSString *)path delegate:(id<HttpRequestDelegate>)vcDelegate
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[self getAuthKey] forHTTPHeaderField:@"X-authKey"];
    
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

+(void) createAuthMutableGet:(NSString *)path delegate:(id<HttpRequestDelegate>)vcDelegate
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[self getAuthKey] forHTTPHeaderField:@"X-authKey"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc]init] completionHandler:
     ^(NSURLResponse *resp, NSData *responseData, NSError *error){
         NSMutableDictionary* respDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 [vcDelegate handleSuccessWithMutableDictionary:respDictionary];
             }
             else
             {
                 [vcDelegate handleError:error];
             }
         });
     }];
    
}

#pragma mark - StaticVariables

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
+(NSString*)getOrganizationName
{
    return _organizationName;
}
+(void)setOrganizationName:(NSString *)name
{
    _organizationName = name;
}

+(void)setRole:(Role)role
{
    _userRole = role;
}
+(Role)getRole
{
    return _userRole;
}
@end

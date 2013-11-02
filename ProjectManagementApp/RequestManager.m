//
//  RequestManager.m
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/2/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+(void) createRequest:(NSString *)path httpMethod:(NSString*)method sentData:(NSDictionary *)dictionary
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    //req.HTTPMethod = method;
    [req setHTTPMethod:method];
    //[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [req setHTTPBody:	[dictionary d]];
//    NSURLResponse* returning = nil;
    NSHTTPURLResponse* returning = nil;
    
    NSError* error = nil;
    
    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&returning error:&error];
    
    
}

@end

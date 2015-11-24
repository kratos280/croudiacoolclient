//
//  Account.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/16.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (void)verifyCredentials {
    CroudiaHTTPClient *httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        SCREEN_NAME = [responseObject valueForKey:@"screen_name"];
        USER_ID = [responseObject valueForKey:@"id"];
        
        // Store userDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:SCREEN_NAME forKey:@"SCREEN_NAME"];
        [userDefaults setValue:USER_ID forKey:@"USER_ID"];
        [userDefaults synchronize];
    };
    
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    [httpClient get:@"account/verify_credentials.json" parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

@end

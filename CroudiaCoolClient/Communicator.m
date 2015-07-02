//
//  Communicator.m
//  CroudiaCool
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Communicator.h"

@implementation Communicator

- (id)init
{
    self = [super init];
    if (self) {
        self.baseURL = BASE_URL;
    }
    return self;
}
- (void)getTimeLine
{
    NSString *url = [self.baseURL stringByAppendingString:@"oauth/token" ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

    NSDictionary *parameters = @{@"grant_type": @"authorization_code", @"client_id": CONSUMER_KEY, @"client_secret": CONSUMER_SECRET, @"code": CODE};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
//
//  Communicator.m
//  CroudiaCool
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Communicator.h"
#import "Global.h"

@implementation Communicator

- (id)init
{
    self = [super init];
    if (self) {
        self.baseURL = BASE_URL;
    }
    return self;
}
- (void)fetchTimeLine
{
    NSString *url = [self.baseURL stringByAppendingString:@"statuses/home_timeline.json"];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedAccessTokenResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)requestAccessTokenURL {
    NSString *url = [self.baseURL stringByAppendingString:@"oauth/token"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"grant_type": @"authorization_code", @"client_id": CONSUMER_KEY, @"client_secret": CONSUMER_SECRET, @"code": CODE};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedAccessTokenResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
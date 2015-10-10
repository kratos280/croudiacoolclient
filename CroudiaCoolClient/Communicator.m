//
//  Communicator.m
//  CroudiaCool
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Global.h"
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
- (void)fetchTimeLine: (NSString *)type
{
    NSLog(@"Access Token: %@", ACCESS_TOKEN);
    NSString *url = nil;
    if ([type isEqualToString:@"Home"]) {
        url = [self.baseURL stringByAppendingString:@"statuses/home_timeline.json"];
    } else {
        url = [self.baseURL stringByAppendingString:@"statuses/public_timeline.json"];
    }
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedTimelineJSON:responseObject type:type];
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

- (void)fetchPostDetail:(NSInteger)postId {
    NSLog(@"Post Id: %d", postId);
    NSString *url = [self.baseURL stringByAppendingString:[NSString stringWithFormat:@"2/statuses/show/%d.json", postId]];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedPostDetailJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)favorite:(NSInteger)postId isFavorited:(BOOL)isFavorited {
    NSString *url = nil;
    if (isFavorited) {
        url = [self.baseURL stringByAppendingString:[NSString stringWithFormat:@"2/favorites/destroy/%d.json", postId]];
    } else {
        url = [self.baseURL stringByAppendingString:[NSString stringWithFormat:@"2/favorites/create/%d.json", postId]];
    }
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)follow:(NSInteger)userId isFollowing:(BOOL)isFollowing {
    NSString *url = nil;
    if (isFollowing) {
        url = [self.baseURL stringByAppendingString:@"friendships/destroy.json"];
    } else {
        url = [self.baseURL stringByAppendingString:@"friendships/create.json"];
    }
    NSDictionary *parameters = @{@"user_id": [NSString stringWithFormat:@"%d", userId]};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchUserInfo:(NSInteger)userId {
    NSString *url = [self.baseURL stringByAppendingString:@"users/show.json"];
    NSDictionary *parameters = @{@"user_id": [NSString stringWithFormat:@"%d", userId]};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedUserInfoJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchMyInfo {
    NSString *url = [self.baseURL stringByAppendingString:@"account/verify_credentials.json"];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate receivedUserInfoJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
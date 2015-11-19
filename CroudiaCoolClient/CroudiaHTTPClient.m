//
//  CroudiaHTTPClient.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/01.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "CroudiaHTTPClient.h"

@implementation CroudiaHTTPClient

+ (CroudiaHTTPClient *)sharedCroudiaHTTPClient {
    static CroudiaHTTPClient *__sharedCroudiaHTTPClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedCroudiaHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return __sharedCroudiaHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)getAccessToken {
    NSString *url = [BASE_URL stringByAppendingString:@"oauth/token"];
    NSDictionary *parameters = @{@"grant_type": @"authorization_code", @"client_id": CONSUMER_KEY, @"client_secret": CONSUMER_SECRET, @"code": CODE};
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveAccessToken:)]) {
         [self.delegate croudiaHTTPClient:self didReceiveAccessToken:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)favorite:(NSInteger)postId isFavorited:(BOOL)isFavorited {
    NSString *url = nil;
    if (isFavorited) {
        url = [BASE_URL stringByAppendingString:[NSString stringWithFormat:@"2/favorites/destroy/%d.json", postId]];
    } else {
        url = [BASE_URL stringByAppendingString:[NSString stringWithFormat:@"2/favorites/create/%d.json", postId]];
    }
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didFavoriteStatus:)]) {
            [self.delegate croudiaHTTPClient:self didFavoriteStatus:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)fetchTimeline:(NSString *)type {
    NSString *url = nil;
    if ([type isEqualToString:@"Home"]) {
        url = [BASE_URL stringByAppendingString:@"statuses/home_timeline.json"];
    } else {
        url = [BASE_URL stringByAppendingString:@"statuses/public_timeline.json"];
    }
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveTimeline:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveTimeline:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)follow:(NSInteger)userId isFollowing:(BOOL)isFollowing {
    NSString *url = nil;
    if (isFollowing) {
        url = [BASE_URL stringByAppendingString:@"friendships/destroy.json"];
    } else {
        url = [BASE_URL stringByAppendingString:@"friendships/create.json"];
    }
    NSDictionary *parameters = @{@"user_id": [NSString stringWithFormat:@"%d", userId]};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveResponse:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveResponse:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)fetchUserInfo:(NSInteger)userId {
    NSString *url = [BASE_URL stringByAppendingString:@"users/show.json"];
    NSDictionary *parameters = @{@"user_id": [NSString stringWithFormat:@"%d", userId]};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveUserInfo:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveUserInfo:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)fetchMyInfo {
    NSString *url = [BASE_URL stringByAppendingString:@"account/verify_credentials.json"];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveUserInfo:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveUserInfo:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)updateStatus:(NSString *)status withMedia:(NSData *)imageData {
    NSString *url = [BASE_URL stringByAppendingString:@"2/statuses/update_with_media.json"];
    NSDictionary *parameters = @{@"status": status};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"media" fileName:@"upload.jpg" mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Post status with media success");
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didUpdateStatus:)]) {
            [self.delegate croudiaHTTPClient:self didUpdateStatus:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Post status error = %@", error);
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)updateStatus:(NSString *)status {
    NSString *url = [BASE_URL stringByAppendingString:@"2/statuses/update.json"];
    NSDictionary *parameters = @{@"status": status};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Post status success");
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didUpdateStatus:)]) {
            [self.delegate croudiaHTTPClient:self didUpdateStatus:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Post status error = %@", error);
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)fetchStatusDetail:(NSInteger)statusId {
    NSString *url = [BASE_URL stringByAppendingString:[NSString stringWithFormat:@"2/statuses/show/%d.json", statusId]];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveStatusDetail:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveStatusDetail:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (void)verifyCredentials {
    NSString *url = [BASE_URL stringByAppendingString:@"account/verify_credentials.json"];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(croudiaHTTPClient:didReceiveVerifyInfo:)]) {
            [self.delegate croudiaHTTPClient:self didReceiveVerifyInfo:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate croudiaHTTPClient:self didFailWithError:error];
    }];
}

- (NSString *)buildURL:(NSString *)apiResourcePath {
    NSString *url = [BASE_URL stringByAppendingString:apiResourcePath];
    return url;
}

- (void)get:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *, id))successCallback failureCallback:(void (^)(NSURLSessionDataTask *, NSError *))failureCallback {
    NSString *url = [self buildURL:apiResourcePath];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successCallback(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCallback(task, error);
    }];
}

@end

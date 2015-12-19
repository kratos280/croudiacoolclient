//
//  CroudiaHTTPClient.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/01.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "CroudiaHTTPClient.h"

// Privated method
@interface CroudiaHTTPClient()
- (NSString *)buildURL:(NSString *)apiResourcePath;
@end

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

- (NSString *)buildURL:(NSString *)apiResourcePath {
    NSString *url = [BASE_URL stringByAppendingString:apiResourcePath];
    return url;
}

# pragma mark Blocks pattern

- (void)get:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *, id))successCallback failureCallback:(void (^)(NSURLSessionDataTask *, NSError *))failureCallback {
    NSString *url = [self buildURL:apiResourcePath];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [self GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        successCallback(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCallback(task, error);
    }];
}

- (void)post:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *, id))successCallback failureCallback:(void (^)(NSURLSessionDataTask *, NSError *))failureCallback {
    NSString *url = [self buildURL:apiResourcePath];
    if (ACCESS_TOKEN) {
        NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
        [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    }
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        successCallback(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCallback(task, error);
    }];
}

- (void)postWithMultiPartForm:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters constructBody:(void (^)(id<AFMultipartFormData>))constructBody successCallback:(void (^)(NSURLSessionDataTask *, id))successCallback failureCallback:(void (^)(NSURLSessionDataTask *, NSError *))failureCallback {
    NSString *url = [self buildURL:apiResourcePath];
    if (ACCESS_TOKEN) {
        NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
        [self.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    }
    [self POST:url parameters:parameters constructingBodyWithBlock:constructBody
       success:^(NSURLSessionDataTask *task, id responseObject) {
           successCallback(task, responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           failureCallback(task, error);
       }];
}

@end

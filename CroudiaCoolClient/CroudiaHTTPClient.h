//
//  CroudiaHTTPClient.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/01.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "Global.h"

@interface CroudiaHTTPClient : AFHTTPSessionManager

+ (CroudiaHTTPClient *)sharedCroudiaHTTPClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)get:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *task, id responseObject))successCallback
failureCallback:(void (^)(NSURLSessionDataTask *task, NSError *error))failureCallback;

- (void)post:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *task, id responseObject))successCallback
failureCallback:(void (^)(NSURLSessionDataTask *task, NSError *error))failureCallback;

- (void)postWithMultiPartForm:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters constructBody:(void (^)(id<AFMultipartFormData> formData))constructBody successCallback:(void (^)(NSURLSessionDataTask *task, id responseObject))successCallback
failureCallback:(void (^)(NSURLSessionDataTask *task, NSError *error))failureCallback;

@end


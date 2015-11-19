//
//  CroudiaHTTPClient.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/01.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CroudiaHTTPClientDelegate.h"
#import "Global.h"

@interface CroudiaHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<CroudiaHTTPClientDelegate>delegate;
+ (CroudiaHTTPClient *)sharedCroudiaHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)fetchTimeline:(NSString *)type;
- (void)getAccessToken;
- (void)fetchHomeTimeline;
- (void)fetchStatusDetail: (NSInteger)statusId;
- (void)favorite:(NSInteger)postId isFavorited:(BOOL)isFavorited;
- (void)follow:(NSInteger)userId isFollowing:(BOOL)isFollowing;
- (void)fetchUserInfo:(NSInteger)userId;
- (void)fetchMyInfo;
- (void)updateStatus:(NSString *)status withMedia:(NSData *)imageData;
- (void)updateStatus:(NSString *)status;
- (void)verifyCredentials;


- (void)get:(NSString *)apiResourcePath parameters:(NSDictionary *)parameters successCallback:(void (^)(NSURLSessionDataTask *task, id responseObject))successCallback
failureCallback:(void (^)(NSURLSessionDataTask *task, NSError *error))failureCallback;

// TODO: private method

- (NSString *)buildURL:(NSString *)apiResourcePath;


@end


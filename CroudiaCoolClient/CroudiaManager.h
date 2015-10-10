//
//  CroudiaManager.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "Communicator.h"
#import "CommunicatorDelegate.h"
#import "CroudiaManagerDelegate.h"

@interface CroudiaManager : NSObject <CommunicatorDelegate>

@property (strong, nonatomic) id<CroudiaManagerDelegate> delegate;
@property (strong, nonatomic) Communicator *communicator;

+ (CroudiaManager*)sharedCroudiaManager;

- (void)fetchTimeline: (NSString*)type;
- (void)getAccessToken;
- (void)fetchHomeTimeline;
- (void)fetchPostDetail: (NSInteger)postId;
- (void)favorite: (NSInteger)postId isFavorited:(BOOL)isFavorited;
- (void)follow: (NSInteger)userId isFollowing:(BOOL)isFollowing;
- (void)fetchUserInfo: (NSInteger)userId;
- (void)fetchMyInfo;

@end

//
//  CroudiaManager.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Global.h"
#import "CroudiaManager.h"
#import "Communicator.h"
#import "CommunicatorDelegate.h"
#import "Post.h"

@implementation CroudiaManager

- (id)init {
    self = [super init];
    if (self) {
        self.communicator = [[Communicator alloc] init];
    }
    self.communicator.delegate = self;
    return  self;
}

// Singleton pattern
+ (id)sharedCroudiaManager {
    static CroudiaManager *sharedCroudiaManager = nil;
    @synchronized(self) {
        if (sharedCroudiaManager == nil) {
            sharedCroudiaManager = [[self alloc] init];
        }
    }
    return sharedCroudiaManager;
}

- (void)dealloc {
    // Should be not called
    abort();
}

- (void)fetchTimeline: (NSString *)type {
    [self.communicator fetchTimeLine:type];
}
- (void)getAccessToken {
    [self.communicator requestAccessTokenURL];
}

- (void)fetchHomeTimeline {
    [self.communicator fetchHomeTimeline];
}

- (void)fetchPostDetail:(NSInteger)postId {
    [self.communicator fetchPostDetail:postId];
}

- (void)favorite:(NSInteger)postId isFavorited:(BOOL)isFavorited {
    [self.communicator favorite:postId isFavorited:isFavorited];
}

- (void)follow:(NSInteger)userId isFollowing:(BOOL)isFollowing {
    [self.communicator follow:userId isFollowing:isFollowing];
}

- (void)fetchUserInfo: (NSInteger)userId {
    [self.communicator fetchUserInfo:userId];
}

- (void)fetchMyInfo {
    [self.communicator fetchMyInfo];
}

#pragma mark - CommunicatorDelegate
- (void)receivedAccessTokenResponse:(NSData *)responseObject {
    NSString *accessToken = [responseObject valueForKey:@"access_token"];
    [self.delegate receivedAccessToken:accessToken];
}

- (void)fetchingTimelineWithError:(NSError *)error {
    
}

- (void)receivedTimelineJSON:(NSData *)responseObject type:(NSString *)type {
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for (NSArray *data in responseObject) {
        Post *post = [[Post alloc] init];
        post.title = [data valueForKey:@"text"];
        post.favoritedCount = [[data valueForKey:@"favorited_count"] integerValue];
        post.id = [[data valueForKey:@"id"] integerValue];
        post.favorited = ([[data valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
        
        NSString *createdAt = [data valueForKey:@"created_at"];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s ZZZ"];
        NSDate *date = [dateFormater dateFromString:createdAt];
        [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s"];
        post.createdAt = [dateFormater stringFromDate:date];
        
        NSArray *userArr = [data valueForKey:@"user"];
        User *user = [[User alloc] init];
        user.id = [[userArr valueForKey:@"id"]integerValue];
        user.name = [userArr valueForKey:@"name"];
        user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
        user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
        post.user = user;
        
        [posts addObject:post];
    }
    
    [self.delegate receivedTimelinePosts:posts type:type];
    
}

- (void)receivedPostDetailJSON:(NSData *)responseObject {
    NSLog(@"%@", responseObject);
}

- (void)receivedResponse:(NSData *)responseObject {
    NSLog(@"%@", responseObject);
}

- (void)receivedUserInfoJSON:(NSData *)responseObject {
    NSArray *userArr = responseObject;
    User *user = [[User alloc] init];
    user.id = [[userArr valueForKey:@"id"]integerValue];
    user.name = [userArr valueForKey:@"name"];
    user.screenName = [userArr valueForKey:@"screen_name"];
    user.description = [userArr valueForKey:@"description"];
    user.url = [userArr valueForKey:@"url"];
    user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
    user.coverImageUrl = [userArr valueForKey:@"cover_image_url_https"];
    user.location = [userArr valueForKey:@"location"];
    user.favoritesCount = [[userArr valueForKey:@"favorites_count"]integerValue];
    user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
    user.followersCount = [[userArr valueForKey:@"followers_count"]integerValue];
    user.statusesCount = [[userArr valueForKey:@"statuses_count"]integerValue];
    
    [self.delegate receivedUserInfo:user];
}


@end

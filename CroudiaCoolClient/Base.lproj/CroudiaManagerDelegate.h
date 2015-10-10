//
//  CroudiaManagerDelegate.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/18.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol CroudiaManagerDelegate <NSObject>

@optional
- (void)receivedAccessToken: (NSString*)accessToken;
- (void)receivedTimelinePosts: (NSArray*)posts type:(NSString*)type;
- (void)receivedUserInfo : (User *)user;
@end




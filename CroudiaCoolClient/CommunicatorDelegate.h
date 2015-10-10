//
//  CommunicatorDelegate.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommunicatorDelegate <NSObject>

- (void)fetchingTimelineWithError:(NSError *)error;
- (void)receivedAccessTokenResponse: (NSData *)responseObject;
- (void)receivedTimelineJSON: (NSData *)responseObject type: (NSString*)type;
- (void)receivedPostDetailJSON: (NSData *)responseObject;
- (void)receivedUserInfoJSON: (NSData *)responseObject;

- (void)receivedResponse: (NSData *)responseObject;

@end

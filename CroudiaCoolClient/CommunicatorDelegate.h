//
//  CommunicatorDelegate.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommunicatorDelegate <NSObject>

- (void)receivedTimelineJSON;
- (void)fetchingTimelineWithError:(NSError *)error;
- (void)receivedAccessTokenResponse: (NSData *)responseObject;

@end

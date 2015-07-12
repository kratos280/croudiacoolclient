//
//  CroudiaManager.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "CroudiaManager.h"
#import "Communicator.h"
#import "CommunicatorDelegate.h"

@implementation CroudiaManager

- (id)init {
    self = [super init];
    if (self) {
        self.communicator = [[Communicator alloc] init];
    }
    self.communicator.delegate = self;
    return  self;
}

- (void)fetchTimeline {
    [self.communicator fetchTimeLine];
}
- (void)getAccessToken {
    [self.communicator requestAccessTokenURL];
}

#pragma mark - CommunicatorDelegate
- (void)receivedAccessTokenResponse:(NSData *)responseObject {
    NSString *accessToken = [responseObject valueForKey:@"access_token"];
    ACCESS_TOKEN = accessToken;
}

- (void)fetchingTimelineWithError:(NSError *)error {
    
}

- (void)receivedTimelineJSON {
    
}


@end

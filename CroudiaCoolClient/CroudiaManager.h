//
//  CroudiaManager.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communicator.h"
#import "CommunicatorDelegate.h"

@interface CroudiaManager : NSObject <CommunicatorDelegate>

@property (strong, nonatomic) Communicator *communicator;

- (void)fetchTimeline;
- (void)getAccessToken;

@end

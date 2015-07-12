//
//  Communicator.h
//  CroudiaCool
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommunicatorDelegate.h"

@interface Communicator : NSObject

@property (strong, nonatomic) id<CommunicatorDelegate> delegate;
@property (strong, nonatomic) NSString *baseURL;

- (void)requestAccessTokenURL;
- (void)fetchTimeLine;

@end

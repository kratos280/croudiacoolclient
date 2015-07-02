//
//  Communicator.h
//  CroudiaCool
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface Communicator : NSObject

@property (strong, nonatomic) NSString *baseURL;

- (void)getTimeLine;

@end

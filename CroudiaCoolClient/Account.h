//
//  Account.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/16.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "CroudiaHTTPClient.h"

@interface Account : NSObject <CroudiaHTTPClientDelegate>

+ (void)verifyCredentials;

@end

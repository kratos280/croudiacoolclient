//
//  Helper.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface Helper : NSObject

+ (BOOL)isConnectedInternet;
+ (void)resizeButtonAccordingText:(UIButton *)button plusWidth:(NSInteger)plusWidth plusHeight:(NSInteger)plusHeight;
+ (NSString *)getSimpleDateTimeStringWithoutTimezone:(NSString *)simpleDateTime;

@end

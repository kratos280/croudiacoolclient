//
//  Helper.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (BOOL)isConnectedInternet {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+ (void)resizeButtonAccordingText:(UIButton *)button plusWidth:(NSInteger)plusWidth plusHeight:(NSInteger)plusHeight {
    CGSize textSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    CGRect buttonFrame = button.frame;
    buttonFrame.size.width = ceilf(textSize.width) + plusWidth;
    buttonFrame.size.height = ceilf(textSize.height) + plusHeight;
    
    [button setFrame:buttonFrame];
}

+ (NSString *)getSimpleDateTimeStringWithoutTimezone:(NSString *)simpleDateTime {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s ZZZ"];
    NSDate *date = [dateFormater dateFromString:simpleDateTime];
    [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s"];
    return [dateFormater stringFromDate:date];
}

@end

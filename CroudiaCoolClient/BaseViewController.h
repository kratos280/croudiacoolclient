//
//  BaseViewController.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/28.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showAlertDialog:(NSString *)title withMessage:(NSString *)message andActionTitle:(NSString *)actionTitle defaultActionCallback:(void (^)())defaultActionCallback;

@end

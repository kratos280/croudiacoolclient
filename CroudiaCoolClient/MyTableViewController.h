//
//  MyTableViewController.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroudiaManager.h"
#import "CroudiaManagerDelegate.h"
#import "PostCell.h"
#import "Post.h"
#import "PostDetailView.h"
#import "CustomButton.h"
#import "PostStatusView.h"
#import "MBProgressHUD.h"
#import "Helper.h"

@interface MyTableViewController : UITableViewController <CroudiaManagerDelegate>

@property (strong, nonatomic) CroudiaManager *croudiaManager;
@property (strong, nonatomic) NSArray *posts;
@property (assign, nonatomic) BOOL *isFavorited;
@property (strong, nonatomic) MBProgressHUD *loadingHUD;

- (void)favorite: (id)sender;

- (void)showWarningAlert:(NSString *)warning;

@end

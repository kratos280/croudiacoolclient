//
//  MyTableViewController.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroudiaHTTPClient.h"
#import "PostCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "CustomButton.h"
#import "PostStatusViewController.h"
#import "MBProgressHUD.h"
#import "Helper.h"
#import "CommentBox.h"

@interface MyTableViewController : UITableViewController

@property (strong, nonatomic) CroudiaHTTPClient *httpClient;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL *isFavorited;
@property (strong, nonatomic) MBProgressHUD *loadingHUD;

- (void)favorite: (id)sender;
- (void)showWarningAlert:(NSString *)warning;
- (void)refreshTimelineTable;

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) CommentBox *commentBox;

@end

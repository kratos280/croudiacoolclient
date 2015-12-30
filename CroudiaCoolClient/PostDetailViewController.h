//
//  PostDetailView.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "CroudiaHTTPClient.h"
#import "Helper.h"
#import "UserInfoViewController.h"
#import "CommentBox.h"
#import "PostCell.h"

@interface PostDetailViewController : BaseViewController

@property (strong, nonatomic) CroudiaHTTPClient *_httpClient;

@property (strong, nonatomic) Post *post;
@property (assign, nonatomic) NSInteger postId;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletePostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) CommentBox *commentBox;

- (IBAction)pressFavoriteButton:(id)sender;
- (IBAction)pressFollowButton:(id)sender;
- (IBAction)pressDeleteButton:(id)sender;
- (IBAction)pressCommentButton:(id)sender;


@end

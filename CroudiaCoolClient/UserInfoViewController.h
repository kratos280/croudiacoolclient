//
//  UserInfoView.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Helper.h"
#import "User.h"
#import "CroudiaHTTPClient.h"
#import "ChangeProfileViewController.h"
#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) User *_user;
@property (assign, nonatomic) NSUInteger _passedUserId;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFollowLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFollowerLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *changeProfileImageButton;
@property (weak, nonatomic) IBOutlet UIButton *changeCoverImageButton;
@property (weak, nonatomic) IBOutlet UIView *summaryView;

- (IBAction)pressChangeProfileImageButton:(id)sender;
- (IBAction)pressChangeCoverImageButton:(id)sender;

@end

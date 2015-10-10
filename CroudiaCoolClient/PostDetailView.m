//
//  PostDetailView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "PostDetailView.h"

@interface PostDetailView()

@end

@implementation PostDetailView

@synthesize post;

- (void)viewDidLoad {
    [super viewDidLoad];

    self._croudiaManager = [[CroudiaManager alloc] init];
    
    self.userProfileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.user.profileImageUrl]]];
    self.titleLabel.text = self.post.title;
    [self.titleLabel sizeToFit];
    self.favoriteInfoLabel.text = [NSString stringWithFormat:@"%d", self.post.favoritedCount];
    [self.favoriteInfoLabel sizeToFit];
    
    self.followButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.followButton.layer.borderWidth = 1.0f;
    self.followButton.layer.cornerRadius = 7.0f;
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:10];
    if (post.user.following) {
        [self.followButton setTitle:@"フォロー中" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followButton.layer.backgroundColor = [UIColor blueColor].CGColor;
    }
    [Helper resizeButtonAccordingText:self.followButton plusWidth:10 plusHeight:10];
    
    [self.titleLabel sizeToFit];
    
    // User profile image Click
    self.userProfileImageView.userInteractionEnabled = YES;
    self.userProfileImageView.multipleTouchEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    [self.userProfileImageView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressFavoriteButton:(id)sender {
    [self._croudiaManager favorite:post.id isFavorited:post.favorited];
    post.favorited = !(post.favorited);
    // Update view
    if (!post.favorited) {
        [self.favoriteButton setTitle:@"お気に入り" forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        post.favoritedCount = post.favoritedCount - 1;
    } else {
        [self.favoriteButton setTitle:@"お気に入り解除" forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        post.favoritedCount = post.favoritedCount + 1;
    }
    
    self.favoriteInfoLabel.text = [NSString stringWithFormat:@"%d", self.post.favoritedCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressFollowButton:(id)sender {
    [self._croudiaManager follow:post.user.id isFollowing:post.user.following];
    post.user.following = !(post.user.following);
    // Update view
    if (!post.user.following) {
        [self.followButton setTitle:@"フォロー" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.followButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [Helper resizeButtonAccordingText:self.followButton plusWidth:10 plusHeight:10];
    } else {

        [self.followButton setTitle:@"フォロー中" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followButton.layer.backgroundColor = [UIColor blueColor].CGColor;
        self.followButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [Helper resizeButtonAccordingText:self.followButton plusWidth:10 plusHeight:10];
        
    }
    
}

- (void)tapProfileImage:(id)sender {
//    UIViewController *userInfoViewController = [[UserInfoView alloc] init];
//    //[self.navigationController pushViewController:userInfoViewController animated:YES];
//    [self presentViewController:userInfoViewController animated:YES completion:nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *userInfoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"userInfoViewController"]; // Storyboard ID
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}
@end

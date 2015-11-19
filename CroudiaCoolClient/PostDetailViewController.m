//
//  PostDetailView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "PostDetailViewController.h"

@interface PostDetailViewController()

@end

@implementation PostDetailViewController

@synthesize post;

- (void)viewDidLoad {
    [super viewDidLoad];

    self._httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    self._httpClient.delegate = self;
    [self._httpClient fetchStatusDetail:self.postId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TODO: Can rebind view by returned responseObject when favorite or follow
- (void)pressFavoriteButton:(id)sender {
    [self._httpClient favorite:post.id isFavorited:post.favorited];
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
    
    self.favoriteInfoLabel.text = [NSString stringWithFormat:@"%d お気に入り", post.favoritedCount];
}

- (IBAction)pressFollowButton:(id)sender {
    [self._httpClient follow:post.user.id isFollowing:post.user.following];
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
    UserInfoViewController *userInfoViewController = (UserInfoViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"]; // Storyboard ID
    userInfoViewController._passedUserId = post.user.id;
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

# pragma mark CroudiaHTTPClient Delegate

- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveStatusDetail:(id)responseObject {
    Post *postObj = [[Post alloc] init];
    postObj.title = [responseObject valueForKey:@"text"];
    postObj.favoritedCount = [[responseObject valueForKey:@"favorited_count"] integerValue];
    postObj.id = [[responseObject valueForKey:@"id"] integerValue];
    postObj.favorited = ([[responseObject valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
    
//    NSString *createdAt = [responseObject valueForKey:@"created_at"];
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//    [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s ZZZ"];
//    NSDate *date = [dateFormater dateFromString:createdAt];
//    [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s"];
//    postObj.createdAt = [dateFormater stringFromDate:date];
    
    NSArray *userArr = [responseObject valueForKey:@"user"];
    User *user = [[User alloc] init];
    user.id = [[userArr valueForKey:@"id"]integerValue];
    user.name = [userArr valueForKey:@"name"];
    user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
    user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
    postObj.user = user;
    
    // Update property
    post = postObj;
    
    // Update View
    self.titleLabel.text = postObj.title;
    [self.titleLabel sizeToFit];
    
    self.followButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.followButton.layer.borderWidth = 1.0f;
    self.followButton.layer.cornerRadius = 7.0f;
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:10];
    if (postObj.user.following) {
        [self.followButton setTitle:@"フォロー中" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followButton.layer.backgroundColor = [UIColor blueColor].CGColor;
    }
    [Helper resizeButtonAccordingText:self.followButton plusWidth:10 plusHeight:10];
    
    self.userProfileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:postObj.user.profileImageUrl]]];
    
    NSArray *entities = [responseObject valueForKey:@"entities"];
    if ([entities count] > 0 && [entities valueForKey:@"media"]) {
        NSArray *media = [entities valueForKey:@"media"];
        if ([[media valueForKey:@"type"] isEqualToString:@"photo"]) {
            NSString *mediaUrl = [media valueForKey:@"media_url_https"];
            UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 240, 150, 150)];
            postImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mediaUrl]]];
            [self.view addSubview:postImageView];
        }
    }
    
    self.favoriteInfoLabel.text = [NSString stringWithFormat:@"%d お気に入り", postObj.favoritedCount];
    [self.favoriteInfoLabel sizeToFit];
    
    if (postObj.favorited == YES) {
        [self.favoriteButton setTitle:@"お気に入り解除" forState:UIControlStateNormal];
        [self.favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    // User profile image Click
    self.userProfileImageView.userInteractionEnabled = YES;
    self.userProfileImageView.multipleTouchEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    [self.userProfileImageView addGestureRecognizer:tapGesture];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

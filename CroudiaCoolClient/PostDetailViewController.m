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

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self._httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        [self didReceiveStatusDetail:responseObject];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    NSString *apiResourcePath = [NSString stringWithFormat:@"2/statuses/show/%d.json", self.postId];
    [self._httpClient get:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseCommentBox:) name:@"closeCommentBox" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressFavoriteButton:(id)sender {
    NSString *apiResourcePath = nil;
    if (post.favorited) {
        apiResourcePath = [NSString stringWithFormat:@"2/favorites/destroy/%d.json", post.id];
    } else {
        apiResourcePath = [NSString stringWithFormat:@"2/favorites/create/%d.json", post.id];
    }
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        BOOL isFavorited = ([[responseObject valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
        NSInteger favoritedCount = [[responseObject valueForKey:@"favorited_count"] integerValue];
        
        post.favorited = isFavorited;
        post.favoritedCount = favoritedCount;
        // Update view
        if (!isFavorited) {
            [self.favoriteButton setTitle:@"お気に入り" forState:UIControlStateNormal];
            [self.favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } else {
            [self.favoriteButton setTitle:@"お気に入り解除" forState:UIControlStateNormal];
            [self.favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        self.favoriteInfoLabel.text = [NSString stringWithFormat:@"%d お気に入り", post.favoritedCount];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    [self._httpClient post:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

- (IBAction)pressFollowButton:(id)sender {
    NSString *apiResourcePath = nil;
    if (post.user.following) {
        apiResourcePath = @"friendships/destroy.json";
    } else {
        apiResourcePath = @"friendships/create.json";
    }
    NSDictionary *parameters = @{@"user_id": [NSString stringWithFormat:@"%d", post.user.id]};
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        BOOL following = ([[responseObject valueForKey:@"following"]integerValue] == 0) ? NO : YES;
        post.user.following = following;
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
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    [self._httpClient post:apiResourcePath parameters:parameters successCallback:successCallback failureCallback:failureCallback];
}

- (IBAction)pressDeleteButton:(id)sender {
    NSString *apiResourcePath = [NSString stringWithFormat:@"2/statuses/destroy/%d.json", post.id];
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTimelineTable" object:self];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    [self._httpClient post:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

- (IBAction)pressCommentButton:(id)sender {
    // Show Comment Box Popup
    self.container.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent  animations:^{
        self.container.transform = CGAffineTransformIdentity;
        [self showCommentBoxPopUp:self.postId];
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

-(void)showCommentBoxPopUp:(NSInteger)statusId {
    CommentBox *commentBoxView = [CommentBox loadFromXib];
    self.commentBox = commentBoxView;
    [self.commentBox setProperties:self toStatus:statusId];
    self.commentBox.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 60);
    
    self.container  = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.container];
    [self.container addSubview:commentBoxView];
}

- (void)didCloseCommentBox:(NSNotification *)notification {
    [self.container removeFromSuperview];
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

- (void)didReceiveStatusDetail:(id)responseObject {
    Post *postObj = [[Post alloc] init];
    postObj.title = [responseObject valueForKey:@"text"];
    postObj.favoritedCount = [[responseObject valueForKey:@"favorited_count"] integerValue];
    postObj.id = [[responseObject valueForKey:@"id"] integerValue];
    postObj.favorited = ([[responseObject valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
    
    NSArray *userArr = [responseObject valueForKey:@"user"];
    User *user = [[User alloc] init];
    user.id = [[userArr valueForKey:@"id"]integerValue];
    user.screenName = [userArr valueForKey:@"screen_name"];
    user.name = [userArr valueForKey:@"name"];
    user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
    user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
    postObj.user = user;
    
    // Update property
    post = postObj;
    
    // Update View
    if ([post.user.screenName isEqualToString:SCREEN_NAME]) {
        self.deletePostButton.hidden = NO;
        self.followButton.hidden = YES;
    } else {
        self.deletePostButton.hidden = YES;
        self.followButton.hidden = NO;
    }
    
    self.titleLabel.text = postObj.title;
    [self.titleLabel setNumberOfLines:0];
        [self.titleLabel sizeToFit];
    
    self.screenNameLabel.text = postObj.user.screenName;
    [self.screenNameLabel sizeToFit];
    
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
            UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 240, 130, 130)];
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
    
    // Quoted status
    NSArray *quotedStatus = [responseObject valueForKey:@"quoted_status"];
    if (quotedStatus) {
        CGFloat quotedStatusYPosition = 430;
        UIView *quotedStatusView = [[UIView alloc] initWithFrame:CGRectMake(10, quotedStatusYPosition, 300, 90)];
        quotedStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        quotedStatusView.backgroundColor = [UIColor grayColor];
        quotedStatusView.layer.cornerRadius = 10;
        [self.view addSubview:quotedStatusView];
        
        NSArray *quotedStatusUser = [quotedStatus valueForKey:@"user"];
        UIImage *quotedStatusProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[quotedStatusUser valueForKey:@"profile_image_url_https"]]]];
        UIImageView *quotedStatusProfileImageView = [[UIImageView alloc] initWithImage:quotedStatusProfileImage];
        quotedStatusProfileImageView.frame = CGRectMake(10, 5, 50, 50);
        [quotedStatusView addSubview:quotedStatusProfileImageView];
        
        UILabel *quotedStatusScreenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 20)];
        quotedStatusScreenNameLabel.text = [quotedStatusUser valueForKey:@"screen_name"];
        quotedStatusScreenNameLabel.font = [UIFont fontWithName:@"AppleGothic" size:12];
        [quotedStatusScreenNameLabel sizeToFit];
        [quotedStatusView addSubview:quotedStatusScreenNameLabel];
        
        UILabel *quotedStatusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 50)];
        quotedStatusTitleLabel.numberOfLines = 0;
//        [quotedStatusTitleLabel sizeToFit];
        quotedStatusTitleLabel.font = [UIFont fontWithName:@"AppleGothic" size:11];
        quotedStatusTitleLabel.text = [quotedStatus valueForKey:@"text"];
        [quotedStatusView addSubview:quotedStatusTitleLabel];
                                           
        UILabel *quotedStatusTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 10)];
        quotedStatusTimeLabel.text = [Helper getSimpleDateTimeStringWithoutTimezone:[quotedStatus valueForKey:@"created_at"]];
        quotedStatusTimeLabel.font = [UIFont fontWithName:@"AppleGothic" size:10];
        [quotedStatusTimeLabel sizeToFit];
        [quotedStatusView addSubview:quotedStatusTimeLabel];
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

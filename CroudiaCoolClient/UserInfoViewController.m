//
//  UserInfoView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SWRevealViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

@synthesize _user, _passedUserId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *summaryView = [[UIView alloc] init];
//    summaryView.frame = CGRectMake(0, 420, 320, 100);
//    [summaryView addSubview:self.countStatusLabel];
//    [summaryView addSubview:self.countFollowLabel];
//    [summaryView addSubview:self.countFollowerLabel];
//    UIView *summaryViewButtom = [[UIView alloc] init];
//    summaryViewButtom.backgroundColor = [UIColor grayColor];
//    summaryViewButtom.frame = CGRectMake(0, 300, summaryView.frame.size.width, 2);
//    [summaryView addSubview:summaryViewButtom];
//
//    summaryView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:summaryView];

    UIView *summaryViewButtom = [[UIView alloc] init];
    summaryViewButtom.backgroundColor = [UIColor grayColor];
    summaryViewButtom.frame = CGRectMake(0, 480, 320, 2);
    [self.view addSubview:summaryViewButtom];
    
    // TODO: Can use USER_ID
    NSString *apiResourcePath = nil;
    NSDictionary *parameters = nil;
    if (_passedUserId) {
        apiResourcePath = @"users/show.json";
        parameters = @{@"user_id": [NSString stringWithFormat:@"%d", _passedUserId]};
    } else {
        apiResourcePath = @"account/verify_credentials.json";
    }
    
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        [self didReceiveUserInfo:responseObject];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    CroudiaHTTPClient *httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    [httpClient get:apiResourcePath parameters:parameters successCallback:successCallback failureCallback:failureCallback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveUserInfo:(id)responseObject {
    //    NSArray *userArr = responseObject;
    //    User *user = [[User alloc] init];
    //    user.id = [[userArr valueForKey:@"id"]integerValue];
    //    user.name = [userArr valueForKey:@"name"];
    //    user.screenName = [userArr valueForKey:@"screen_name"];
    //    user.description = [userArr valueForKey:@"description"];
    //    user.url = [userArr valueForKey:@"url"];
    //    user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
    //    user.coverImageUrl = [userArr valueForKey:@"cover_image_url_https"];
    //    user.location = [userArr valueForKey:@"location"];
    //    user.favoritesCount = [[userArr valueForKey:@"favorites_count"]integerValue];
    //    user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
    //    user.followersCount = [[userArr valueForKey:@"followers_count"]integerValue];
    //    user.statusesCount = [[userArr valueForKey:@"statuses_count"]integerValue];
    //
    //    _user = user;
    
    NSArray *userArr = responseObject;
    self.nameLabel.text = [userArr valueForKey:@"name"];
    self.descriptionLabel.text = [[userArr valueForKey:@"description"] isKindOfClass:[NSNull class]] ? nil : [userArr valueForKey:@"description"];
    self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userArr valueForKey:@"profile_image_url_https"]]]];
    NSData *coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userArr valueForKey:@"cover_image_url_https"]]];
    if (coverImageData) {
        self.coverImageView.image = [UIImage imageWithData:coverImageData];
    } else {
        self.coverImageView.image = [UIImage imageNamed:@"profile-cover-default.jpeg"];
    }
    self.countStatusLabel.text = [NSString stringWithFormat:@"%@ ささやき", [userArr valueForKey:@"statuses_count"]];
    self.countFollowLabel.text = [NSString stringWithFormat:@"%@ フォロー", [userArr valueForKey:@"friends_count"]];
    self.countFollowerLabel.text = [NSString stringWithFormat:@"%@ フォロワー", [userArr valueForKey:@"followers_count"]];
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

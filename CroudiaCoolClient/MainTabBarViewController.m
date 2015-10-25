//
//  MainTabBarView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "SWRevealViewController.h"
#import "LeftMenuViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // For add globally slide menu button at here
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
//    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
//    UIBarButtonItem *slideMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newsfeed.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
//    
//    navigationItem.leftBarButtonItem = slideMenu;
//    [navigationBar pushNavigationItem:navigationItem animated:NO];
//    [self.view addSubview:navigationBar];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

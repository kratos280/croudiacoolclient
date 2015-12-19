//
//  PublicTimelineView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "PublicTimelineViewController.h"

@interface PublicTimelineViewController ()

@end

@implementation PublicTimelineViewController {
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Public";
    [self.loadingHUD show:YES];
    
    //    dispatch_queue_t fetchQueue = dispatch_queue_create("Fetch Queue",NULL);
    //    dispatch_async(fetchQueue, ^(void) {
    //        [self fetchPublicTimeline];
    //    });
    [self fetchTimeline];
    
    [self.refreshControl addTarget:self action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
    
    // Notification Observe
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTimelineTable:) name:@"refreshTimelineTable" object:nil];
}

- (void)fetchTimeline {
    NSString *apiResourcePath = @"statuses/public_timeline.json";
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        for (NSArray *data in responseObject) {
            Post *post = [[Post alloc] init];
            post.title = [data valueForKey:@"text"];
            post.favoritedCount = [[data valueForKey:@"favorited_count"] integerValue];
            post.id = [[data valueForKey:@"id"] integerValue];
            post.favorited = ([[data valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
            
            NSString *createdAt = [data valueForKey:@"created_at"];
            post.createdAt = [Helper getSimpleDateTimeStringWithoutTimezone:createdAt];
            
            NSArray *userArr = [data valueForKey:@"user"];
            User *user = [[User alloc] init];
            user.id = [[userArr valueForKey:@"id"]integerValue];
            user.name = [userArr valueForKey:@"name"];
            user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
            user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
            post.user = user;
            
            [posts addObject:post];
        }
        
        self.posts = posts;
        [self.tableView reloadData];
        [self.loadingHUD hide:YES];
        
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        [self showWarningAlert:error.description];
    };
    
    [self.httpClient get:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

- (void)refreshTimeline {
    if (![Helper isConnectedInternet]) {
        [self showWarningAlert:@"No Internet Connection"];
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self fetchTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Notifications

- (void)refreshTimelineTable:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[PostDetailViewController class]]) {
        [self fetchTimeline];
    };
}

#pragma mark - Table view data source


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

@end

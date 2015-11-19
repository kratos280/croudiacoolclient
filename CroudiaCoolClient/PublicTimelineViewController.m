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
    
    self.httpClient =[CroudiaHTTPClient sharedCroudiaHTTPClient];
    self.httpClient.delegate = self;
    
    //    dispatch_queue_t fetchQueue = dispatch_queue_create("Fetch Queue",NULL);
    //    dispatch_async(fetchQueue, ^(void) {
    //        [self fetchPublicTimeline];
    //    });
    [self.httpClient fetchTimeline:@"Public"];
    
    [self.refreshControl addTarget:self action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
}

// FIXME: temporary to fix refresh control
- (void)viewDidAppear:(BOOL)animated {
    self.httpClient.delegate = self;
}

- (void)refreshTimeline {
    if (![Helper isConnectedInternet]) {
        [self showWarningAlert:@"No Internet Connection"];
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self.httpClient fetchTimeline:@"Public"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CroudiaHTTPClient Delegate

- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveTimeline:(id)responseObject {
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for (NSArray *data in responseObject) {
        Post *post = [[Post alloc] init];
        post.title = [data valueForKey:@"text"];
        post.favoritedCount = [[data valueForKey:@"favorited_count"] integerValue];
        post.id = [[data valueForKey:@"id"] integerValue];
        post.favorited = ([[data valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
        
        NSString *createdAt = [data valueForKey:@"created_at"];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s ZZZ"];
        NSDate *date = [dateFormater dateFromString:createdAt];
        [dateFormater setDateFormat:@"E, d MMM yyyy H:m:s"];
        post.createdAt = [dateFormater stringFromDate:date];
        
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
}

- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveAccessToken:(id)responseObject {
    // ???: Why getAccessToken also be called at here
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

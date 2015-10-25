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
    dispatch_queue_t fetchQueue = dispatch_queue_create("Fetch Queue",NULL);
    dispatch_async(fetchQueue, ^(void) {
        [self fetchPublicTimeline];
    });
    [self.refreshControl addTarget:self action:@selector(fetchPublicTimeline) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchPublicTimeline {
    if (![Helper isConnectedInternet]) {
        [self showWarningAlert:@"No Internet Connection"];
        [self.refreshControl endRefreshing];
        return;
    }
    [self.croudiaManager fetchTimeline:@"Public"];
}

- (void)receivedTimelinePosts:(NSArray *)posts type:(NSString *)type {
    self.posts = posts;
    [self.tableView reloadData];
    [self.loadingHUD hide:YES];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  HomeView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "HomeTimelineViewController.h"

@interface HomeTimelineViewController ()
@end

@implementation HomeTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loadingHUD show:YES];
    self.title = @"Home";
    
    self.httpClient.delegate = self;
    [self.httpClient fetchTimeline:@"Home"];
    
    [self.refreshControl addTarget:self action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    self.httpClient.delegate = self;
}

- (void)refreshTimeline {
    if (![Helper isConnectedInternet]) {
        [self showWarningAlert:@"No Internet Connection"];
        [self.refreshControl endRefreshing];
        return;
    }
    
    [self.httpClient fetchTimeline:@"Home"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark CroudiaHTTPClient Delegate

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

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showPostDetail" sender:self];
}

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showPostDetail"]) {
//        PostDetailView *postDetailView = [segue destinationViewController];
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Post *post = [self.posts objectAtIndex:indexPath.row];
//        postDetailView.post = post;
//    }
//}

@end

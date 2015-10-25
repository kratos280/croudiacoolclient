//
//  LeftMenuViewController.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/10/24.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SWRevealViewController.h"
#import "PublicTimelineViewController.h"
#import "HomeTimelineViewController.h"
#import "UserInfoViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    menuItems = @[@"title", @"public_timeline", @"home_timeline", @"favorite", @"user_info"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    if ([cellIdentifier isEqualToString:@"public_timeline"]) {
        PublicTimelineViewController *destViewController = [[PublicTimelineViewController alloc] init];
        UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:destViewController];
        [self.revealViewController pushFrontViewController:navigationViewController animated:YES];
    } else if ([cellIdentifier isEqualToString:@"home_timeline"]) {
        HomeTimelineViewController *destViewController = [[HomeTimelineViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:destViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES]; 
    } else if ([cellIdentifier isEqualToString:@"favorite"]) {
        
    } else if ([cellIdentifier isEqualToString:@"user_info"]) {
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UserInfoViewController *destViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//        [self.revealViewController pushFrontViewController:destViewController animated:YES];
        return;
    } else {
        return;
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

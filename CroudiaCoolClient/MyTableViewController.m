//
//  MyTableViewController.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "MyTableViewController.h"
#import "SWRevealViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

@synthesize httpClient;
@synthesize posts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    
    if (![Helper isConnectedInternet]) {
        [self showWarningAlert:@"No Internet Connection"];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"投稿" style:UIBarButtonItemStyleDone target:self action:@selector(showPostStatusModal:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    // Side bar menu
    UIBarButtonItem *slideMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = slideMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Loading HUD
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.dimBackground = YES;
    self.loadingHUD.labelText = @"Loading";
    
    // Initialize the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    if (refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
    }
    self.refreshControl = refreshControl;
    
    // Notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseCommentBox:) name:@"closeCommentBox" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)favorite:(id)sender {
    CustomButton *target = (CustomButton *)sender;
    
    NSString *apiResourcePath = nil;
    if (target.isFavoried) {
        apiResourcePath = [NSString stringWithFormat:@"2/favorites/destroy/%d.json", target.postId];
    } else {
        apiResourcePath = [NSString stringWithFormat:@"2/favorites/create/%d.json", target.postId];
    }
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        BOOL isFavorited = ([[responseObject valueForKey:@"favorited"]integerValue] == 0) ? NO : YES;
        target.isFavoried = isFavorited;
        // Update view
        if (!isFavorited) {
            [target setTitle:@"お気に入り" forState:UIControlStateNormal];
            [target setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } else {
            [target setTitle:@"お気に入り解除" forState:UIControlStateNormal];
            [target setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        [self showWarningAlert:error.localizedDescription];
    };
    
    [httpClient post:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

- (void)showWarningAlert:(NSString *)warning {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:warning preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// TODO: Add delete confirm dialog
- (void)deletePost:(id)sender {
    CustomButton *deleteButton = (CustomButton *)sender;
    NSString *apiResourcePath = [NSString stringWithFormat:@"2/statuses/destroy/%d.json", deleteButton.postId];
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        // TODO: Can re-fetch timeline
        [posts removeObjectAtIndex:deleteButton.tableCellRow];
        [self.tableView reloadData];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    
    [self.httpClient post:apiResourcePath parameters:nil successCallback:successCallback failureCallback:failureCallback];
}

- (void)refreshTimelineTable {
    [self.tableView reloadData];
}

#pragma mark Comment Box

- (void)pressCommentButton:(id)sender {
    CustomButton *commentButton = (CustomButton *)sender;
    
    // Show Comment Box Popup
    self.container.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent  animations:^{
        self.container.transform = CGAffineTransformIdentity;
        [self showCommentBoxPopUp:commentButton.postId];
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

-(void)showCommentBoxPopUp:(NSInteger)statusId {
    CommentBox *commentBoxView = [CommentBox loadFromXib];
    self.commentBox = commentBoxView;
    [self.commentBox setProperties:self toStatus:statusId];
    self.commentBox.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 100);
    // TODO: show comment box near clicked position
    
    self.container  = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.container];
    [self.container addSubview:commentBoxView];
}

- (void)didCloseCommentBox:(NSNotification *)notification {
    [self.container removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (posts) {
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Post *post = [posts objectAtIndex:indexPath.row];
    cell.titleLabel.text = post.title;
    cell.timeLabel.text = post.createdAt;
    cell.userNameLabel.text = post.user.name;
    cell.userProfileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.user.profileImageUrl]]];
    
    CustomButton *deleteButton = (CustomButton *)[cell viewWithTag:109];
    if (post.user.id == [USER_ID integerValue]) {
        deleteButton.hidden = NO;
        deleteButton.postId = post.id;
        deleteButton.tableCellRow = indexPath.row;
        [deleteButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        deleteButton.hidden = YES;
    }
    
    // Action buttons
    CustomButton *favoriteButton = (CustomButton*)[cell viewWithTag:101];
    favoriteButton.postId = post.id;
    favoriteButton.isFavoried = post.favorited;
    if (post.favorited == YES) {
        [favoriteButton setTitle:@"お気に入り解除" forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [favoriteButton setTitle:@"お気に入り" forState:UIControlStateNormal];
        [favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [favoriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton *commentButton = (CustomButton *)[cell viewWithTag:102];
    commentButton.postId = post.id;
    [commentButton addTarget:self action:@selector(pressCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPostDetail"]) {
        PostDetailViewController *postDetailView = [segue destinationViewController];
        postDetailView.navigationItem.backBarButtonItem.title = @"Public Timeline";
        postDetailView.title = @"Post Detail";
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *post = [self.posts objectAtIndex:indexPath.row];
        postDetailView.postId = post.id;
    }
}

- (void)showPostStatusModal:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *postStatusViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"postStatusViewController"]; // Storyboard ID
    [self presentModalViewController:postStatusViewController animated:YES];
}

@end

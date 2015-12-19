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

@implementation UserInfoViewController {
    NSString *_updateImageApiPath; // Use for store update image api resource path
}

@synthesize _user, _passedUserId;

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIView *summaryViewButtom = [[UIView alloc] init];
//    summaryViewButtom.backgroundColor = [UIColor grayColor];
//    summaryViewButtom.frame = CGRectMake(0, 480, 320, 2);
//    [self.view addSubview:summaryViewButtom];
    self.summaryView.hidden = YES;
    
    _updateImageApiPath = nil;
    
    [self fetchUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:@"refreshUserInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchUserInfo {
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

- (void)didReceiveUserInfo:(id)responseObject {
    NSArray *userArr = responseObject;
    User *user = [[User alloc] init];
    user.name = [userArr valueForKey:@"name"];
    user.screenName = [userArr valueForKey:@"screen_name"];
    user.description = [userArr valueForKey:@"description"];
    user.url = [userArr valueForKey:@"url"];
    user.profileImageUrl = [userArr valueForKey:@"profile_image_url_https"];
    user.coverImageUrl = [userArr valueForKey:@"cover_image_url_https"];
    user.location = [userArr valueForKey:@"location"];
    user.favoritesCount = [[userArr valueForKey:@"favorites_count"]integerValue];
    user.following = ([[userArr valueForKey:@"following"]integerValue] == 0) ? NO : YES;
    user.followersCount = [[userArr valueForKey:@"followers_count"]integerValue];
    user.statusesCount = [[userArr valueForKey:@"statuses_count"]integerValue];
    user.friendsCount = [[userArr valueForKey:@"friends_count"] integerValue];
    
    _user = user;
    
    self.nameLabel.text = user.name;
    [self.nameLabel sizeToFit];
    self.descriptionLabel.text = [user.description isKindOfClass:[NSNull class]] ? nil : user.description;
    [self.descriptionLabel sizeToFit];
    if ([user.screenName isEqualToString:SCREEN_NAME]) {
        self.changeProfileButton.hidden = NO;
        self.changeProfileImageButton.hidden = NO;
        self.changeCoverImageButton.hidden = NO;
    } else {
        self.changeProfileButton.hidden = YES;
        self.changeProfileImageButton.hidden = YES;
        self.changeCoverImageButton.hidden = YES;
    }
    self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageUrl]]];
    NSData *coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.coverImageUrl]];
    if (coverImageData) {
        self.coverImageView.image = [UIImage imageWithData:coverImageData];
    } else {
        self.coverImageView.image = [UIImage imageNamed:@"profile-cover-default.jpeg"];
    }
    self.countStatusLabel.text = [NSString stringWithFormat:@"%d ささやき", user.statusesCount];
    [self.countStatusLabel sizeToFit];
    self.countFollowLabel.text = [NSString stringWithFormat:@"%d フォロー", user.friendsCount];
    [self.countFollowLabel sizeToFit];
    self.countFollowerLabel.text = [NSString stringWithFormat:@"%d フォロワー", user.followersCount];
    [self.countFollowerLabel sizeToFit];
}

- (void)refreshUserInfo:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[ChangeProfileViewController class]]) {
        [self fetchUserInfo];
    }
}

- (void)updateAccountImage:(NSData *)imageData {
    if (!imageData || !_updateImageApiPath) {
        return;
    }
    
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        if ([_updateImageApiPath isEqualToString:@"account/update_profile_image.json"]) {
            _user.profileImageUrl = [responseObject valueForKey:@"profile_image_url_https"];
            self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_user.profileImageUrl]]];
        } else if ([_updateImageApiPath isEqualToString:@"account/update_cover_image.json"]) {
            _user.coverImageUrl = [responseObject valueForKey:@"cover_image_url_https"];
            NSData *coverImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_user.coverImageUrl]];
            if (coverImageData) {
                self.coverImageView.image = [UIImage imageWithData:coverImageData];
            } else {
                self.coverImageView.image = [UIImage imageNamed:@"profile-cover-default.jpeg"];
            }
        }

        _updateImageApiPath = nil; // Reset
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error.debugDescription);
        _updateImageApiPath = nil; // Reset
        [self showAlertDialog:nil withMessage:@"Update Fail" andActionTitle:@"OK"];
    };
    void (^constructBody)(id<AFMultipartFormData>) = ^void (id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"update.jpg" mimeType:@"image/png"];
    };
    
    CroudiaHTTPClient *httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    [httpClient postWithMultiPartForm:_updateImageApiPath parameters:nil constructBody:constructBody successCallback:successCallback failureCallback:failureCallback];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showChangeProfile"]) {
        ChangeProfileViewController *destController = (ChangeProfileViewController *)segue.destinationViewController;
        destController.user = self._user;
    }
}

// ???: Simulator can not get UIImagePickerControllerOriginalImage with allowsEditting = NO, as 1 simulator bug
- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *error = @"No Camera Available!";
        [self showAlertDialog:nil withMessage:error andActionTitle:@"OK"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)pressChangeProfileImageButton:(id)sender {
    if (![_user.screenName isEqualToString:SCREEN_NAME]) {
        return;
    }
    NSString *apiResourcePath = @"account/update_profile_image.json";
    _updateImageApiPath = apiResourcePath;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }];
    UIAlertAction *selectPhoto = [UIAlertAction actionWithTitle:@"Select Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:takePhoto];
    [alertController addAction:selectPhoto];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pressChangeCoverImageButton:(id)sender {
    if (![_user.screenName isEqualToString:SCREEN_NAME]) {
        return;
    }
    NSString *apiResourcePath = @"account/update_cover_image.json";
    _updateImageApiPath = apiResourcePath;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }];
    UIAlertAction *selectPhoto = [UIAlertAction actionWithTitle:@"Select Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:takePhoto];
    [alertController addAction:selectPhoto];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

# pragma mark UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
        NSData *imageData = UIImagePNGRepresentation(imageToUse);
        [self updateAccountImage:imageData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

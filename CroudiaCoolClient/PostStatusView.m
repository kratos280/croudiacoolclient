//
//  PostStatusView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/15.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "PostStatusView.h"

@interface PostStatusView ()

@end

@implementation PostStatusView

#define TEXTVIEW_CHARACTER_COUNT_MAX 372
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Post Status"];
    UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
//    [postButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postStatus:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(postStatus:)];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
//    [cancelButton setImage:[UIImage imageNamed:@"plain.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPost:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPost:)];
    
    navigationItem.rightBarButtonItem = postButtonItem;
    navigationItem.leftBarButtonItem = cancelButtonItem;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    // UITextView
    self.remainTextCount.text = [NSString stringWithFormat:@"%d", TEXTVIEW_CHARACTER_COUNT_MAX];
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.delegate = self;
    self.textView.text = @"";
    
    if (!self.imageView.image) {
        self.removeImageButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postStatus:(id)sender {
    NSString *statusText = self.textView.text;
    if ([statusText length] == 0) {
        NSString *error = @"入力してください！";
        [self showErrorAlert:error];
        return;
    }
    
    [self updateStatusWithMedia:statusText];
}

- (void)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger length = [[textView text] length] + 1;
    NSInteger remainCount = TEXTVIEW_CHARACTER_COUNT_MAX - length;
    self.remainTextCount.text = [NSString stringWithFormat:@"%d", remainCount];
    if (length > TEXTVIEW_CHARACTER_COUNT_MAX) {
        return NO;
    }
    return YES;
}

- (void)showErrorAlert: (NSString*)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"!Alert" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [errorAlert show];
}

- (void)updateStatusWithMedia: (NSString*)status {
    
    NSString *url = [BASE_URL stringByAppendingString:@"2/statuses/update_with_media.json"];
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    NSDictionary *parameters = @{@"status": status};
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(self.imageView.image){
            [formData appendPartWithFileData:imageData name:@"media" fileName:@"upload.jpg" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Post status success");
        [self didPostStatus];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Post status error = %@", error);
        NSString *alertText = @"Post Status Fail";
        [self showErrorAlert:alertText];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)removeImage:(id)sender {
    self.imageView.image = Nil;
    self.removeImageButton.hidden = true;
}


- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *error = @"No Camera Available!";
        [self showErrorAlert:error];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.removeImageButton.hidden = false;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPostStatus {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.textView.text =@"";
    self.imageView.image = Nil;
}

@end

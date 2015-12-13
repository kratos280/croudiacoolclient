//
//  CommentBox.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/12/06.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "CommentBox.h"

@implementation CommentBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CommentBox *)loadFromXib {
    CommentBox *commentBoxView = (CommentBox *)[[[NSBundle mainBundle] loadNibNamed:@"CommentBox" owner:self options:nil] objectAtIndex:0];
    commentBoxView.layer.cornerRadius = 5;
    commentBoxView.commentTextView.layer.cornerRadius = 5;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:commentBoxView.bounds];
    commentBoxView.layer.masksToBounds = NO;
    commentBoxView.layer.shadowRadius = 5;
    commentBoxView.layer.shadowColor = [UIColor whiteColor].CGColor;
    commentBoxView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    commentBoxView.layer.shadowOpacity = 0.5f;
    commentBoxView.layer.shadowPath = shadowPath.CGPath;
    return commentBoxView;
}

- (void)setProperties:(UIViewController *)parentVC toStatus:(NSInteger)statusId {
    self.parentVC = parentVC;
    self.targetStatusId = statusId;
}

- (void)clearProperties {
    self.parentVC = nil;
    self.targetStatusId = 0;
}

- (void)showMessageAlert: (NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:defaultAction];
    [self.parentVC presentViewController:alertController animated:YES completion:nil];
}

// ???: Simulator can not get UIImagePickerControllerOriginalImage with allowsEditting = NO, as 1 simulator bug
- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.parentVC presentViewController:picker animated:YES completion:nil];
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showMessageAlert:@"No Camera Available"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.parentVC presentViewController:picker animated:YES completion:nil];
}

- (IBAction)postComment:(id)sender {
    if (!self.targetStatusId || self.targetStatusId == 0) {
        return;
    }
    NSString *statusText = self.commentTextView.text;
    if ([statusText length] == 0) {
        NSString *error = @"入力してください！";
        [self showMessageAlert:error];
        return;
    }
    
    NSDictionary *parameters = @{@"id": [NSString stringWithFormat:@"%d", self.targetStatusId], @"status": statusText};
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        self.commentTextView.text =@"";
        self.selectedImage = nil;
        [self showMessageAlert:@"Successfully post comment"];
        [self closeBox:self];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        self.commentTextView.text =@"";
        self.selectedImage = nil;
        [self showMessageAlert:@"Post Comment Fail"];
        [self closeBox:self];
    };
    
    self.httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    
    NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
    if (imageData) {
        void (^constructBody)(id<AFMultipartFormData>) = ^void (id<AFMultipartFormData> formData)
        {
            [formData appendPartWithFileData:imageData name:@"media" fileName:@"upload.jpg" mimeType:@"image/png"];
        };
        [self.httpClient postWithMultiPartForm:@"2/statuses/comment_with_media.json" parameters:parameters constructBody:constructBody successCallback:successCallback failureCallback:failureCallback];
    } else {
        [self.httpClient post:@"2/statuses/comment.json" parameters:parameters successCallback:successCallback failureCallback:failureCallback];
    }
}

- (IBAction)pressGetImageButton:(id)sender {
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
    
    [self.parentVC presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)closeBox:(id)sender {
    [self clearProperties];
    self.commentTextView.text =@"";
    self.selectedImage = nil;
    
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeCommentBox" object:self userInfo:nil];
}

# pragma mark ImagePicker Delegate

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
        self.selectedImage = imageToUse;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

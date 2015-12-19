//
//  CommentBox.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/12/06.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroudiaHTTPClient.h"

@interface CommentBox : UIView <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) CroudiaHTTPClient *httpClient;

@property (weak, nonatomic) UIViewController *parentVC;
@property (assign, nonatomic) NSInteger targetStatusId;

+ (CommentBox *)loadFromXib;
- (IBAction)postComment:(id)sender;
- (IBAction)pressGetImageButton:(id)sender;
- (IBAction)closeBox:(id)sender;

- (void)setProperties:(UIViewController *)parentVC toStatus:(NSInteger)statusId;
- (void)clearProperties;
- (void)showMessageAlert:(NSString *)message;

@end

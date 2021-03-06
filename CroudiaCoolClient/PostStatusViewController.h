//
//  PostStatusView.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/08/15.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "CroudiaHTTPClient.h"
#import "BaseViewController.h"

@interface PostStatusViewController : BaseViewController <UITextViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) CroudiaHTTPClient *httpClient;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *remainTextCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *removeImageButton;

- (IBAction)removeImage:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

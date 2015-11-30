//
//  ChangeProfileViewController.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/25.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CroudiaHTTPClient.h"

@interface ChangeProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)save:(id)sender;

@end

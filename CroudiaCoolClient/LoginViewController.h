//
//  LoginView.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroudiaHTTPClient.h"
#import "Account.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

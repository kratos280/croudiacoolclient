//
//  LoginView.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import "MainTabBarViewController.h"
#import "LeftMenuViewController.h"
#import "SWRevealViewController.h"

@implementation LoginViewController

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    NSString *url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&state=%@", AUTHORIZE_URL, CONSUMER_KEY, STATE];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] host] isEqualToString:REDIRECT_HOST]) {
        NSString *code = nil;
        NSArray *parameters = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString *parameter in parameters ) {
            NSArray *parameterArr = [parameter componentsSeparatedByString:@"="];
            NSString *key = [parameterArr objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                code = [parameterArr objectAtIndex:1];
                break;
            }
        }
        if (code != nil) {
            CODE = code;
            // get access token
            CroudiaHTTPClient *httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
            httpClient.delegate = self;
            [httpClient getAccessToken];
            
            if (ACCESS_TOKEN) {
    
                // Get Auth user info
                [Account verifyCredentials];
                
                [self.webView removeFromSuperview];
                
                // goto main tab bar
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LeftMenuViewController *leftMenuViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
                MainTabBarViewController *mainTabBarViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                
                SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftMenuViewController frontViewController:mainTabBarViewController];
                [self presentViewController:revealViewController animated:YES completion:nil];
            }
            return NO;
        } else {
            // TODO handle error
        }
        
    }
    return YES;
}

# pragma mark CroudiaManagerDelegate

- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveAccessToken:(id)responseObject {
    ACCESS_TOKEN = [responseObject valueForKey:@"access_token"];
    REFRESH_TOKEN = [responseObject valueForKey:@"refresh_token"];
    TOKEN_EXPIRES_IN = [responseObject valueForKey:@"expires_in"];
    
    // Store by NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:ACCESS_TOKEN forKey:@"ACCESS_TOKEN"];
    [userDefaults setValue:REFRESH_TOKEN forKey:@"REFRESH_TOKEN"];
    [userDefaults setValue:TOKEN_EXPIRES_IN forKey:@"TOKEN_EXPIRES_IN"];
    [userDefaults synchronize];
}

@end

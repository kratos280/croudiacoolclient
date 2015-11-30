//
//  AppDelegate.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/02.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LeftMenuViewController.h"
#import "MainTabBarViewController.h"
#import "SWRevealViewController.h"
#import "Global.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelError];
#endif
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults valueForKey:@"ACCESS_TOKEN"];
        NSString *expires = [userDefaults valueForKey:@"TOKEN_EXPIRES_IN"];
    NSLog(@"%@", expires);
    if (!accessToken) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *rootViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"have user default access token %@",
              accessToken);
        //[self verifyCredentials];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *rootViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)verifyCredentials {
    NSString *url = [BASE_URL stringByAppendingString:@"account/verify_credentials.json"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN];
    [manager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"BBB");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainTabBarViewController *mainTabBarViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
            LeftMenuViewController *leftMenuViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
            SWRevealViewController *rootViewController = [[SWRevealViewController alloc] initWithRearViewController:leftMenuViewController frontViewController:mainTabBarViewController];
                    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self.window setRootViewController:rootViewController];
            [self.window makeKeyAndVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ABCD");
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *rootViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

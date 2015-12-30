//
//  ChangeProfileViewController.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/25.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "ChangeProfileViewController.h"

@interface ChangeProfileViewController ()

@end

@implementation ChangeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.text = self.user.name;
    self.locationTextField.text = self.user.location;
    self.urlTextField.text = self.user.url;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = 0.5;
    self.descriptionTextView.layer.cornerRadius = 8.0f;
    self.descriptionTextView.text = self.user.description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    void (^successCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserInfo" object:self];
        
        void (^defaultActionCallback)() = ^void () {
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self showAlertDialog:nil withMessage:@"Successfully Update" andActionTitle:@"OK" defaultActionCallback:defaultActionCallback];
    };
    void (^failureCallback)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@", error);
    };
    NSDictionary *parameters = @{@"name": self.nameTextField.text, @"location": self.locationTextField.text, @"url": self.urlTextField.text, @"description": self.descriptionTextView.text};
    
    CroudiaHTTPClient *httpClient = [CroudiaHTTPClient sharedCroudiaHTTPClient];
    [httpClient post:@"account/update_profile.json" parameters:parameters successCallback:successCallback failureCallback:failureCallback];
}

@end

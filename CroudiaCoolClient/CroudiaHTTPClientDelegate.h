//
//  CroudiaHTTPClientDelegate.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/11/01.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CroudiaHTTPClient.h"

@class CroudiaHTTPClient;

@protocol CroudiaHTTPClientDelegate <NSObject>

@optional
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveAccessToken:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didFavoriteStatus:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didFailWithError:(NSError *)error;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveTimeline:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveUserInfo:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didUpdateStatus:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveStatusDetail:(id)responseObject;
- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveVerifyInfo:(id)responseObject;

- (void)croudiaHTTPClient:(CroudiaHTTPClient *)client didReceiveResponse:(id)responseObject;

@end

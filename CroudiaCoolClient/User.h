//
//  User.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/12.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *coverImageUrl;
@property (strong, nonatomic) NSString *location;
@property (assign, nonatomic) NSInteger favoritesCount;
@property (assign, nonatomic) BOOL following;
@property (assign, nonatomic) NSInteger followersCount;
@property (assign, nonatomic) NSInteger statusesCount;
@property (assign, nonatomic) NSInteger friendsCount;
@end

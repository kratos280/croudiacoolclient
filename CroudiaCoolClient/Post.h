//
//  Post.h
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/18.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Post : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) BOOL favorited;
@property (assign, nonatomic) NSInteger favoritedCount;
@property (strong, nonatomic) NSString *createdAt;

@property (strong, nonatomic) User *user;

@end

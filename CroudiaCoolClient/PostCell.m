//
//  PostCell.m
//  CroudiaCoolClient
//
//  Created by Tran Ngoc Cuong on 2015/07/19.
//  Copyright (c) 2015年 ___AA___. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    self.layer.borderColor = [[UIColor grayColor]CGColor];
//    self.layer.borderWidth = 1;
    
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 6)];
    separatorLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:separatorLineView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 92, (self.bounds.size.width -20), 0.4)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}

@end

//
//  CollectionReusableView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "CollectionReusableView.h"


@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.frame = CGRectMake(0, 15, KWIDTH, 15);
        label.text = @"分享后好友每次点击，均可获得金币奖励";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = HUIRED;
        label.textAlignment = 1;
        [self addSubview:label];
    }
    return self;
}

@end

//
//  UITabBar+Badge.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)


- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

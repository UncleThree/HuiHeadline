//
//  HHNavigationBackViewCreater.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHNavigationBackViewCreater.h"

@implementation HHNavigationBackViewCreater


+ (UIView *_Nullable)customBarItemWithTarget:(id _Nullable)target
                                      action:(nullable SEL)action {
    
    return  [self customBarItemWithTarget:target action:action text:@"返回"];
}




+ (UIView *)customBarItemWithTarget:(id)target
                             action:(nullable SEL)action
                               text:(NSString *)text {
   
    UIFont *font = [UIFont systemFontOfSize:18];
    CGFloat backWidth = [HHFontManager sizeWithText:text font:font maxSize:CGSizeMake(CGFLOAT_MAX, 40)].width + 2;
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, 15 + 6 + backWidth, 40);
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    backImgV.center = CGPointMake(backImgV.center.x, backView.center.y);
    backImgV.contentMode = UIViewContentModeScaleAspectFit;
    backImgV.image = [[UIImage imageNamed:@"返回(3)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [backView addSubview:backImgV];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(backImgV)+ 6, 0, backWidth, 40)];
    label.text = text;
    label.font = font;
    [backView addSubview:label];
    return backView;
}

+ (UIView *)customNavigationWithTarget:(id)target
                              action:(nullable SEL)action
                                text:(NSString *)text{
   
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    UINavigationController *nav = [UINavigationController new];
    CGFloat navigationBarHeight = nav.navigationBar.frame.size.height;
    nav = nil;
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, statusBarHeight + navigationBarHeight)];
    navigationView.backgroundColor = [UIColor whiteColor];
    UIView *view = [self customBarItemWithTarget:target action:action text:text];
    view.frame = CGRectMake(12, statusBarHeight, W(view), navigationBarHeight);
    view.center = CGPointMake(view.center.x, statusBarHeight + navigationBarHeight / 2);
    [navigationView addSubview:view];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(navigationView) - 0.5, KWIDTH, 0.5)];
    line.backgroundColor = BLACK_153;
    [navigationView addSubview:line];
    
    return navigationView;
    
}


@end

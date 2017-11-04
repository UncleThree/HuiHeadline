//
//  HHHeadlineAwardHUD.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineAwardHUD.h"
#import "HHeadlineAwardView.h"
#import "HHHeadlineAwardInstructionView.h"

@interface HHHeadlineAwardHUD ()



@end


static MBProgressHUD *HUD = nil;

static HHeadlineAwardView *myView = nil;

static HHHeadlineAwardInstructionView *insView = nil;

static UIView *screenView = nil;

@implementation HHHeadlineAwardHUD


+ (void)showHUDWithText:(NSString *)text
              addToView:(UIView *)view
               animated:(BOOL)animated {
    
    [self hideHUDAnimated:animated];
    HUD = nil;
    HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.label.text = text;
    
}


+ (void)showHUDWithText:(NSString *)text
               animated:(BOOL)animated {
    
    [self hideHUDAnimated:animated];
    HUD = nil;
    HUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:animated];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.label.text = text;
    
}

+ (void)hideHUDAnimated:(BOOL)animated {
    
    [HUD hideAnimated:animated];
    
}



+ (void)showImageView:(NSString *)imageName
                coins:(NSInteger)coins
            animation:(BOOL)animation
         originCenter:(CGPoint)originCenter
            addToView:(UIView *)view
             duration:(float)duration {
    
    if (myView) {
        return;
    }
    myView = [[HHeadlineAwardView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH / 3 + 20, KWIDTH / 3 + 20) coins:coins imageName:imageName];
    
    myView.center = originCenter;
    
    if (view) {
        [view addSubview:myView];
    } else {
        [[self currentView] addSubview:myView];
    }
    
    if (animation) {
        [self transformToLarge:YES originCenter:originCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideMyViewToOriginCenter:originCenter];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [myView removeFromSuperview];
            myView = nil;
        });
    }
    
}


+ (void)hideMyViewToOriginCenter:(CGPoint)originCenter {
    
    [self transformToLarge:NO originCenter:originCenter];
    
}

///从下面弹出的动画
+ (void)transformToLarge:(BOOL)toLarge
               originCenter:(CGPoint)originCenter{
    
    CGFloat duration = 0.5;
    CGAffineTransform small = CGAffineTransformMakeScale(0.01f, 0.01f);
    
    CGAffineTransform big = CGAffineTransformMakeScale(1.0f, 1.0f);
    CGPoint origin = originCenter;
    CGPoint center = CGPointMake(KWIDTH / 2, KHEIGHT / 2 - 44);
    //平移
    [UIView animateWithDuration:duration animations:^{
        myView.center = toLarge ? center : origin;
    } completion:^(BOOL finished) {
        
        if (!toLarge && finished) {
            [myView removeFromSuperview];
            myView = nil;
        }
    }];
    //缩放
    myView.transform = toLarge ? small : big;
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:duration];
    myView.transform = toLarge ? big : small;
    [UIView commitAnimations];
    
    
    
}



//时段奖励的view

+ (void)showInstructionView {
    
    [self hideInstructionView];
    screenView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    screenView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    insView = [[HHHeadlineAwardInstructionView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH - 36 * 2, KHEIGHT / 3)];
    insView.center = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    [screenView addSubview:insView];
    [[UIApplication sharedApplication].keyWindow addSubview:screenView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:screenView];
    screenView.userInteractionEnabled = YES;
    [screenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenViewClickAction)]];
    
    
}




+ (void)screenViewClickAction {
    
    [self hideInstructionView];
}

+ (void)hideInstructionView {
    
    [screenView removeFromSuperview];
    screenView = nil;
    
}



+ (void)showMessage:(NSString *)message
           animated:(BOOL)animated
           duration:(int)duration {
    if ([message isKindOfClass:[NSError class]]) {
        message = message.debugDescription;
    }
    [self showMessage:message hideTouch:NO animated:YES duration:duration];
}


+ (void)showMessage:(NSString *)message
           hideTouch:(BOOL)hideTouch
           animated:(BOOL)animated
           duration:(int)duration {
    
    [self hideHUDAnimated:animated];
    HUD = nil;
    HUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:NO];
    
    if (message.length > 20) {
        HUD.detailsLabel.text = message;
        HUD.detailsLabel.numberOfLines = 0;
    } else {
        HUD.label.text = message;
    }
    HUD.contentColor = [UIColor whiteColor];
    HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = hideTouch;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:animated];
    });
    
}

+ (void)hideMessageAnimated:(BOOL)animated {
    
    [HUD hideAnimated:animated];
    
}


+ (UIView *)currentView{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
    }
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    if (!controller) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return controller.view;
}



//+ (void)showHUDWithImageName:(NSString *)imageName
//             backgroundColor:(UIColor *)color
//                    animated:(BOOL)animated{
//
//    [self hideHUDAnimated:animated];
//    UIView *currentView = [self currentView];
//    if (!currentView) {
//        return;
//    }
//    [self hideHUDAnimated:NO];
//    HUD = nil;
//    HUD = [[MBProgressHUD alloc] initWithView:currentView];
//    HUD.removeFromSuperViewOnHide = YES;
//    [currentView addSubview:HUD];
//    HUD.customView = ({
//        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        imgV.image = [UIImage imageNamed:imageName];
//        imgV;
//    });
//    HUD.mode = MBProgressHUDModeCustomView;
//
//    HUD.bezelView.backgroundColor = color ? : [UIColor clearColor];
//
////    HUD.label.text = @"test";
//    [HUD showAnimated:animated];
//
//}


@end

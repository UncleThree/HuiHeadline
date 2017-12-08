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
#import "HHMineFillInvitedCodeView.h"

@interface HHHeadlineAwardHUD ()



@end


static MBProgressHUD *HUD = nil;

static MBProgressHUD *HUDMessage = nil;
///award
static HHeadlineAwardView *myView = nil;
///alert
static HHHeadlineAwardInstructionView *insView = nil;
///qrcode
static HHMineFillInvitedCodeView *codeView = nil;

static UIView *screenView = nil;

static UIView *qrScreenView = nil;

@implementation HHHeadlineAwardHUD


+ (void)showHUDWithText:(NSString *)text
              addToView:(UIView *)view
               animated:(BOOL)animated
                timeout:(NSInteger)timeout {
    
    [self showHUDWithText:text addToView:view animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:animated];
    });
}

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
               animated:(BOOL)animated
                timeout:(NSInteger)timeout {
    
    [self showHUDWithText:text animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [HUD hideAnimated:animated];
    });
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
            [myView removeFromSuperview];
            myView = nil;
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
    CGFloat scale = CGFLOAT_W(3.6);
    insView = [[HHHeadlineAwardInstructionView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH - 36 * 2, KHEIGHT / scale) title:@"时段奖励" message:@"送金币啦，每小时打开惠头条进入首页，均可获得50金币的时段奖励，具体金额以实际获得金币奖励为准！" left:nil right:@"我知道了" target:self rightTarget:self leftAction:nil rightAction:@selector(hideInstructionView)];
    insView.center = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    insView.layer.cornerRadius = 5;
    [screenView addSubview:insView];
    [[UIApplication sharedApplication].keyWindow addSubview:screenView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:screenView];
    screenView.userInteractionEnabled = YES;
    [screenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenViewClickAction)]];
    
}

//登录状态错误
+ (void)showLoginErrorViewWithTarget:(id)target
                              action:(SEL)action {
    
    [self hideLoginErrorView];
    screenView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    screenView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    CGFloat scale = 4.5;
    insView = [[HHHeadlineAwardInstructionView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH - 36 * 2, KHEIGHT / scale) title:@"温馨提示" message:@"您处于未登录状态，请您先登录" left:@"以后再说" right:@"立即登录" target:self rightTarget:target leftAction:@selector(hideLoginErrorView) rightAction:action];
    insView.center = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    insView.layer.cornerRadius = 5;
    [screenView addSubview:insView];
    UIWindow *currentView = [UIApplication sharedApplication].keyWindow;
    if ([self currentView] == currentView) {
        return;
    }

    [currentView addSubview:screenView];
    [currentView bringSubviewToFront:screenView];
    screenView.userInteractionEnabled = YES;
    [screenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenViewClickAction)]];
    
}

//视频页提醒
+ (void)showVideoReminderView {
    
    [self hideLoginErrorView];
    screenView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    screenView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    CGFloat scale = CGFLOAT_W(3.0);
    insView = [[HHHeadlineAwardInstructionView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH - 36 * 2, KHEIGHT / scale) title:@"温馨提示" message:@"点击进入“视频详情页”，边看视频，边领取金币奖励！\n\n注：点击视频底部白色区域进入视频详情页。" left:nil right:@"我知道了" target:nil rightTarget:self leftAction:nil rightAction:@selector(hideLoginErrorView)];
    insView.center = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    insView.layer.cornerRadius = 5;
    [screenView addSubview:insView];
    //    UIView *currentView = [self currentView];
    UIWindow *currentView = [UIApplication sharedApplication].keyWindow;
    if ([self currentView] == currentView) {
        return;
    }
    
    [currentView addSubview:screenView];
    [currentView bringSubviewToFront:screenView];
    screenView.userInteractionEnabled = YES;
    [screenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLoginErrorView)]];
    
}



+ (void)hideLoginErrorView {
    

    [screenView removeFromSuperview];
    screenView = nil;
}


//填写二维码
+ (UIView *)initQrcodeViewWithTarget:(id)target
                             action1:(SEL)action1
                             action2:(SEL)action2{
    
    [self hideQrView];
    qrScreenView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    qrScreenView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    
    CGFloat scale = 0.25;
    codeView = [[HHMineFillInvitedCodeView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH - 36 * 2, KHEIGHT * scale) target:target action:action1 action2:action2];
    codeView.center = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    codeView.layer.cornerRadius = 5;
    [qrScreenView addSubview:codeView];
    qrScreenView.userInteractionEnabled = YES;
    [qrScreenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideQrView)]];
    
    return qrScreenView;
    
}

+ (void)hideQrView {
    
    [qrScreenView removeFromSuperview];
    qrScreenView = nil;
    
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
        NSLog(@"%@",message);
        return;
    }
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    [self showMessage:message hideTouch:NO animated:YES duration:duration];
}


+ (void)showMessage:(NSString *)message
           hideTouch:(BOOL)hideTouch
           animated:(BOOL)animated
           duration:(int)duration {
    
    if ([message isKindOfClass:[NSError class]] ) {
        if ([message.description containsString:@"似乎已断开与互联网的连接"]) {
            message = @"似乎已断开与互联网的连接";
        } else if ([message.description containsString:@"请求超时"]) {
            message = @"请求超时";
        }
        else {
            
            NSLog(@"%@",message);
            return;
        }
    }
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    
    [HUDMessage hideAnimated:animated];
    HUDMessage = nil;
    HUDMessage = [MBProgressHUD showHUDAddedTo:[self currentView] animated:NO];
    
    
    HUDMessage.label.text = message;
    HUDMessage.label.numberOfLines = 0;

    HUDMessage.contentColor = [UIColor whiteColor];
    HUDMessage.bezelView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    HUDMessage.mode = MBProgressHUDModeText;
    HUDMessage.removeFromSuperViewOnHide = YES;
    HUDMessage.userInteractionEnabled = hideTouch;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUDMessage hideAnimated:animated];
    });
    
}

+ (void)hideMessageAnimated:(BOOL)animated {
    
    [HUDMessage hideAnimated:animated];
    
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

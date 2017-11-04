//
//  HHHeadlineAwardHUD.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHHeadlineAwardHUD : NSObject



+ (void)hideHUDAnimated:(BOOL)animated;

+ (void)showHUDWithText:(NSString *)text
              addToView:(UIView *)view
               animated:(BOOL)animated;

+ (void)showHUDWithText:(NSString *)text
               animated:(BOOL)animated;


+ (void)showImageView:(NSString *)imageName
                coins:(NSInteger)coins
            animation:(BOOL)animation
         originCenter:(CGPoint)originCenter
            addToView:(UIView *)view
             duration:(float)duration;

+ (void)showInstructionView;
+ (void)hideInstructionView;


+ (void)showMessage:(NSString *)message
           animated:(BOOL)animated
           duration:(int)duration;

+ (void)showMessage:(NSString *)message
          hideTouch:(BOOL)hideTouch
           animated:(BOOL)animated
           duration:(int)duration;

+ (void)hideMessageAnimated:(BOOL)animated;

@end

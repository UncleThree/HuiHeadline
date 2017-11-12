//
//  HHHeadlineAwardInstructionView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHeadlineAwardInstructionView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      message:(NSString *)messge
                         left:(NSString *)left
                        right:(NSString *)right
                       target:(id)target
                  rightTarget:(id)rightTarget
                   leftAction:(SEL)leftAction
                  rightAction:(SEL)rightAction;

@end

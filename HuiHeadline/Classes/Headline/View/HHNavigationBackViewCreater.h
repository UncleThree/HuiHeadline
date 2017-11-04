//
//  HHNavigationBackViewCreater.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHNavigationBackViewCreater : NSObject

+ (UIView *_Nullable)customBarItemWithTarget:(id _Nullable)target
                             action:(nullable SEL)action
                               text:(NSString *_Nullable)text;

+ (UIView *_Nullable)customBarItemWithTarget:(id _Nullable)target
                                      action:(nullable SEL)action;


///自定义导航栏
+ (UIView *_Nullable)customNavigationWithTarget:(id _Nullable )target
                                action:(nullable SEL)action
                                           text:(NSString *_Nullable)text;



@end

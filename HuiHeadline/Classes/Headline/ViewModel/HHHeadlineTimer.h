//
//  HHHeadlineTimer.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHHeadlineTimer : NSObject

//开始倒计时
+ (void)startTimer:(NSInteger)secound
            target:(NSObject *)target
          function:(SEL)function;

@end

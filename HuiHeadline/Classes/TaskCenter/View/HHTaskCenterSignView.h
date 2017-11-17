//
//  HHTaskCenterSignView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTaskCenterSignView : UIView

///0未签到
- (instancetype)initWithFrame:(CGRect)frame
                        state:(int)state
                         coin:(NSString *)coin;


@end

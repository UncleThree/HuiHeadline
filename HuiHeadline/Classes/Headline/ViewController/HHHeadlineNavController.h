//
//  HHHeadlineNavController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHeadlineNavController : UINavigationController

///首页是否appear 首页appear的时候再发起时段奖励请求
@property (nonatomic)BOOL appear;

@property(nonatomic, strong)UILabel *timeLabel;

- (void)checkHourAward;

@end

//
//  HHSignRecordResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHSignRecordResponse : NSObject

///第几天签到
@property (nonatomic,assign)int day;
///0 待签到 1明天签到(已经签到)
@property (nonatomic,assign)int state;
///每天签到奖励
@property (nonatomic, strong)NSArray<NSString *> *signDailyRewards;
@end

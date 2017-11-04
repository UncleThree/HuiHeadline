//
//  HHReadSychDurationResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHReadSychDurationResponse : NSObject

///0成功 10失败  1超过每天最大时长？
@property (nonatomic)int state;

@property (nonatomic)int incCredit;

@property (nonatomic, copy)NSString *channel;

@property (nonatomic)long token;

@property (nonatomic, copy)NSString *virifyCode;

@end

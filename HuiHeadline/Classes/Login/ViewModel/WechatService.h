//
//  WechatService.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/3.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHWeixinAccountResponse.h"

@interface WechatService : NSObject

typedef void (^WechatHandler)(id error,id result);

@property (nonatomic,copy)WechatHandler handler;

+ (WechatService *)sharedWechat;

- (void)loginToWechat:(WechatHandler)callback;

- (void)bindToWechat:(WechatHandler)callback;

- (void)authorizeToWechat:(void(^)(id error, HHWeixinAccount *account))callback;

@end

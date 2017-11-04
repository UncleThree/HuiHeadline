//
//  WechatService.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/3.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatService : NSObject


+ (WechatService *)sharedWechat;

- (void)loginToWechat:(void(^)(id error , id result))callback;

- (void)bindToWechat:(void(^)(id error , id result))callback;

@end

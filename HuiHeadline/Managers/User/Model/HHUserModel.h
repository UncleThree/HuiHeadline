//
//  HHUserModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHUserInfo.h"

/*
    short state = -1;
 
    String loginId;//登录id
 
	// 阅读赚钱的详情页广告渠道
    String channel;//东方或腾讯
 
	private UserInfo userInfo;

 */
@interface HHUserModel : NSObject

@property (nonatomic, assign)short state;

@property (nonatomic, assign)short statusCode;
@property (nonatomic, copy)NSString *loginId;
@property (nonatomic, copy)NSString *channel;
@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)HHUserInfo *userInfo;

@end

//
//  HHWeixinAccountResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHWeixinAuthorizedResponse : HHResponse

@property (nonatomic, strong)NSString *headPortrait;

@property (nonatomic, strong)NSString *nickName;

@property (nonatomic, strong)NSString *openId;

@property (nonatomic, strong)NSString *phone;

@property (nonatomic, strong)NSString *realName;

@end

@interface HHWeixinAccount : NSObject

@property (nonatomic, strong)NSString *headPortrait;

@property (nonatomic, strong)NSString *nickName;

@property (nonatomic, strong)NSString *openId;

@property (nonatomic, strong)NSString *phone;

@property (nonatomic, strong)NSString *realName;

@end

@interface HHWeixinAccountResponse : HHResponse

@property (nonatomic, strong)HHWeixinAccount *weixinAccount;

@end

//
//  ProductCategory.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/12/5.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    
    VIRTUAL = 1,
    VIRTUAL_RECHARGE = 1001,
    VIRTUAL_RECHARGE_PHONE_BILL = 1001001,
    VIRTUAL_RECHARGE_PHONE_TRAFFIC = 1001002,
    VIRTUAL_WITHDRAW = 1002,
    VIRTUAL_WITHDRAW_TO_ALIPAY = 1002001,
    VIRTUAL_WITHDRAW_TO_WECHAT_WALLET = 1002002,
    VIRTUAL_COUPON = 1003,
    VIRTUAL_COUPON_JINGDONG_E_CARD = 1003001,
    REAL = 2,
    REAL_CAREFULLY_CHOSEN = 2001,
    REAL_CAREFULLY_CHOSEN_DAILY_NECCESSARY = 2001001,
    
} ProductCategoryType;

@interface ProductCategory : NSObject

@end

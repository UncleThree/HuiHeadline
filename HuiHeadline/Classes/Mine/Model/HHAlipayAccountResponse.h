//
//  HHAlipayAccountResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHAlipayAccount : NSObject

@property (nonatomic, strong)NSString *account;

@property (nonatomic, strong)NSString *name;

@end

@interface HHAlipayAccountResponse : HHResponse

@property (nonatomic, strong)HHAlipayAccount *alipayAccount;

@end

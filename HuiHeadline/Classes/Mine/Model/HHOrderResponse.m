//
//  HHOrderResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHOrderResponse.h"

@implementation HHOrderInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"orderId":@"id"};
}

@end



@implementation HHOrderResponse

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"orderInfoList":@"HHOrderInfo"};
}

@end

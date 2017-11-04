//
//  HHProductIndoResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHProductIndoResponse.h"

@implementation HHProductIndoResponse

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"productOutlineList":@"HHProductOutline"};
}

@end

@implementation HHProductOutline

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"productOutlineId":@"id"};
}

@end

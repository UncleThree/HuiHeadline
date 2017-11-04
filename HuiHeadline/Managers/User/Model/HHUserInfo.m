//
//  HHUserInfo.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserInfo.h"

@implementation HHUserInfo

- (NSString *)description {

    return [NSString stringWithFormat:@"user_id = %ld, nickName = %@, phone = %@", _user_id, _nickName , _phone];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"user_id" : @"id"
             };
}

- (NSString *)phone_sec {
    if (!_phone) {
        return @"";
    } else {
        return [_phone stringByReplacingCharactersInRange:(NSMakeRange(3, 4)) withString:@"****"];
    }
    
}

- (NSString *)genderString {
    
    if (_gender == 1) {
        return @"男";
    } else if (_gender == 2) {
        return @"女";
    } else {
        return nil;
    }
    
}

@end

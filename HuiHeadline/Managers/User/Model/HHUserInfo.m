//
//  HHUserInfo.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserInfo.h"

@implementation HHUserCity

@end

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
    
    if (_phone.length >= 7) {
        return [_phone stringByReplacingCharactersInRange:(NSMakeRange(3, 4)) withString:@"****"];
    }
    return nil;

}

- (NSString *)genderString {
    
    self.isNew = _isNew;
    if (_gender == 1) {
        return @"男";
    } else if (_gender == 2) {
        return @"女";
    } else {
        return nil;
    }
    
}

- (BOOL)isNew {
    
    if (_registerTime) {
        
        return _registerTime / 1000 > 1510717404;
    }
    
    return YES;
    
}



@end

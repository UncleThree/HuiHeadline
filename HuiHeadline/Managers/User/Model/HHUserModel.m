//
//  HHUserModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserModel.h"

@implementation HHUserModel

- (NSString *)description {
    
    return [NSString stringWithFormat:@"state = %d, channel = %@, loginId = %@, userInfo = {%@}, msg = %@", _state,_channel, _loginId, _userInfo, _msg];
}



@end

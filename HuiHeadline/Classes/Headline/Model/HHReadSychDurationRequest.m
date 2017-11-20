//
//  HHReadSychDurationRequest.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHReadSychDurationRequest.h"

@implementation HHReadSychDurationRequest

- (instancetype)init {
    
    if (self = [super init]) {
        self.channel = [HHUserManager sharedInstance].currentUser.channel;
        self.token = [HHUserManager sharedInstance].sychDurationResponse.token;
        self.virifyCode = [HHUserManager sharedInstance].sychDurationResponse.virifyCode;
    }
    return self;
    
}

@end

//
//  HHHeadlineNetwork.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHHeadlineNetwork : NSObject

//发起获取奖励的请求
+ (void)getRewardsRequestWithUserId:(long)userId
                            loginId:(NSString *)loginId
                         appVersion:(int)appVersion
                           position:(int)position
                            handler:(void (^)(id response, NSError *error))handler;

@end

//
//  HspUtil.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HspUtil.h"

@implementation HspUtil

+ (NSString *)getUserInfo {
    
    if (!HHUserManager.sharedInstance.currentUser.loginId) {
        return nil;
    }
    NSMutableDictionary *userDict = [(NSDictionary *)[[HHUserManager sharedInstance].currentUser mj_JSONObject] mutableCopy];
    NSDictionary *userInfo = [HHUserManager.sharedInstance.currentUser.userInfo mj_JSONObject];
    [userDict removeObjectForKey:@"userInfo"];
    [userDict setValuesForKeysWithDictionary:userInfo];
    
    
    return [userDict mj_JSONString];
    
}

+ (NSDictionary *)startActivity:(NSString *)paramater {
    NSDictionary *dict = [paramater mj_JSONObject];
//    NSString *activity = dict[@"activity"];
//    NSArray  *data = dict[@"data"];
//    NSString *pkg = dict[@"pkg"];
    
    return dict;
    
}

@end

//
//  HHTaskCenterNetwork.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskCenterNetwork.h"


@implementation HHTaskCenterNetwork

///弹幕显示 提现通知
+ (void)requestForSignNotificationList:(Block)callback {
    
    
    [HHNetworkManager postRequestWithUrl:k_sign_notification_list parameters:nil isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
           NSDictionary *dict = [respondsStr mj_JSONObject];
            if ([dict[@"statusCode"] integerValue] == 200) {
                NSArray *result = dict[@"notificationList"];
                callback(nil, result);
            } else {
                callback([respondsStr mj_JSONObject],nil);
            }
        }
    }];
    
}

///获取用户签到信息
+ (void)requestForSignRecord:(void(^)(id error, HHSignRecordResponse *response))callback {
    
    [HHNetworkManager postRequestWithUrl:k_sign_record parameters:nil isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            if ([dict[@"statusCode"] integerValue] == 200) {
                HHSignRecordResponse *response = [HHSignRecordResponse mj_objectWithKeyValues:dict];
                callback(nil,response);
            }
        }
    }];
}

///签到
+ (void)sign:(void(^)(id error, HHSignResponse *response))callback  {
    
    [HHNetworkManager postRequestWithUrl:k_sign parameters:nil isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHSignResponse *response = [HHSignResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }
        
    }];
    
}


+ (void)requstNewBieTaskList:(void(^)(id error,NSArray<HHUserNewbieTask *> *tasks))callback {
    
    [HHNetworkManager postRequestWithUrl:k_user_newbie_task parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHUserNewbieTaskResponse *response = [HHUserNewbieTaskResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response.newbieTaskList);
            } else {
                callback(response.msg,nil);
            }
            
        }
        
    }];
}


+ (void)requestDailyTaskList:(void(^)(id error,HHUserDailyTaskResponse *response))callback {
    
    [HHNetworkManager postRequestWithUrl:k_user_daily_task parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHUserDailyTaskResponse *response = [HHUserDailyTaskResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg, nil);
            }
            
        }
        
    }];
    
}

+ (void)drawTaskReward:(BOOL)isNewBie
                taskId:(NSInteger)taskId
              callback:(void(^)(id error, HHUserDrawTaskRewardResponse *response))callback {
    
    NSString *url = nil;
    if (isNewBie) {
        url = k_user_newbie_draw;
    } else {
        url = k_user_daily_draw;
    }
    NSDictionary *parameters = @{
                           @"taskId":[NSNumber numberWithInteger:taskId]
                           };
    [HHNetworkManager postRequestWithUrl:url parameters:parameters isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHUserDrawTaskRewardResponse *response = [HHUserDrawTaskRewardResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg, nil);
            }
            
        }
        
    }];
    
}



@end

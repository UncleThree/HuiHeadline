
//
//  HHLoginNetwork.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHLoginNetwork.h"
#import "HHJSONToDictionaty.h"
#import "HHReadConfigResponse.h"

@interface HHLoginNetwork ()


@end


@implementation HHLoginNetwork


+ (void)checkLogin:(void(^)(id error , id result))callback {
    
    [HHNetworkManager postRequestWithUrl:k_account_check_login parameters:nil isEncryptedJson:YES otherArg:@{@"appendUserInfo":@YES} handler:^(NSString *respondsStr, NSError *error) {
       
        if (error && [error.description containsString:@"unauthorized"]) {
            callback(@"unauthorized",nil);
        } else if (error) {
            callback(error,nil);
        } else {
            callback(error, respondsStr);
        }
    }];
    
}





+ (void)loginRequestWithPhone:(NSString *)phone
                     password:(NSString *)password
                       handler:(void(^)(NSString *respondsStr, id error))handler
{
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSDictionary *parameter = @{
                                @"phone":phone,
                                @"password":password,
                                @"deviceId":uuid,
                                @"deviceExtra":[NSNull null],
                                @"appExtra":[NSNull null]
                                };
    [HHNetworkManager postRequestWithUrl:k_login_url parameters:parameter isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHUserModel *user = [HHUserModel mj_objectWithKeyValues:dict];
            
            if (user.statusCode == 200) {
                [HHUserManager sharedInstance].currentUser  = user;
                handler(user.msg,nil);
            } else {
                handler(nil,user.msg);
            }
            
        } else {
            handler(nil,error);
        }
        
    }];

    
}

+ (void)authorizeWeixinWithCode:(NSString *)code
                       callback:(void(^)(id error , id result))callback{
    NSDictionary *parameters = @{
                                 @"code":code
                                 };
    NSDictionary *otherArg = @{@"appendUserInfo":@1};
    [HHNetworkManager postRequestWithUrl:k_authorize_wx parameters:parameters isEncryptedJson:YES otherArg:otherArg handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil, response.msg);
            } else {
                callback(response.msg, nil);
            }
            
        }
    }];
    
}

///0 ali login 1 wechat login 2 wechat bind 
+ (void)loginRequstByThirdPartyType:(NSInteger)type
                               code:(NSString *)code
                           callback:(void(^)(id error , id result))callback {
    
    NSDictionary *parameters = @{
                                 @"code":code,
                                 @"deviceId":UUID,
                                 @"deviceExtra":@"",
                                 @"appExtra":@""
                                 };
    
    NSDictionary *otherArg = type == 2 ? @{@"appendUserInfo":@1} : nil;
    [HHNetworkManager postRequestWithUrl:type == 0 ? k_login_by_ali : (type == 1 ? k_login_by_wx : k_bind_wx) parameters:parameters isEncryptedJson:YES otherArg:otherArg handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            callback(error,nil);
        } else {
            ///bind wechat
            if (type == 2) {
                NSDictionary *dict = [respondsStr mj_JSONObject];
                HHResponse *response = [HHResponse mj_objectWithKeyValues:dict];
                if (response.statusCode == 200) {
                    callback(nil, response.msg ? : @"成功");
                } else {
                    callback(response.msg, nil);
                }
                
            } else {
                //login
                NSDictionary *dict = [respondsStr mj_JSONObject];
                HHUserModel *user = [HHUserModel mj_objectWithKeyValues:dict];
                if (user.statusCode == 200) {
                    
                    [HHUserManager sharedInstance].currentUser  = user;
                    callback(nil,user.msg);
                    
                    
                } else {
                    callback(user.msg,nil);
                }
            }
           
        }
    }];
}


+ (void)sendSms:(NSString *)phone
           type:(SendSmsType)type
        handler:(void(^)(NSString *msg, id error))handler {
    
    NSDictionary *paramaters = @{
                                 @"phone":phone,
                                 @"type":[NSNumber numberWithInteger:type]
                                 };
//    NSDictionary *other = @{@"requestType":@"json"};
    [HHNetworkManager postRequestWithUrl:k_verify_send parameters:paramaters isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            handler(nil, error);
        
        }
        else {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            if ([dict[@"statusCode"] intValue] == 200) {
                handler(k_sendsms_success,nil);
            } else {
                handler(dict[@"msg"], nil);
            }
        }
    }];
    
    
}


+ (void)requestReadConfig {
    
    [HHNetworkManager postRequestWithUrl:k_readConfig_url parameters:nil isEncryptedJson:NO otherArg:@{@"requestType" : @"json", @"appendUserInfo":@YES} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHReadConfigResponse *readConfig = [HHReadConfigResponse mj_objectWithKeyValues:dict[@"readConfig"]];
            [HHUserManager sharedInstance].readConfig = readConfig;
        } else {
            Log(error);
        }
        
    }];
    
}






@end

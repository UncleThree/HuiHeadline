
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


+ (void)checkLogin:(void(^)(id error , NSString * result))callback {
    
    [HHNetworkManager postRequestWithUrl:k_account_check_state parameters:nil isEncryptedJson:YES otherArg:@{@"CheckLogin":@YES} handler:^(NSString *respondsStr, NSError *error) {
       
        if (error && [error.description containsString:@"unauthorized"]) {
            callback(@"unauthorized",nil);
        } else if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(error, response.msg);
        }
    }];
    
}





+ (void)loginRequestWithPhone:(NSString *)phone
                     password:(NSString *)password
                       handler:(void(^)(NSString *respondsStr, id error))handler
{
    
    
    NSDictionary *parameter = @{
                                @"phone":phone,
                                @"password":password,
                                @"deviceId":UUID,//UUID
                                @"blackbox":FMDeviceManager.sharedManager->getDeviceInfo(),
                                @"deviceExtra":[HHDeviceUtils  deviceExtra],
                                @"appExtra":[HHDeviceUtils  appExtra]
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

+ (void)registWithPhone:(NSString *)phone
               password:(NSString *)password
             verifyCode:(NSString *)verifyCode
             inviteCode:(NSString *)inviteCode
                handler:(void(^)(id error, NSString *response))handler {
    
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    

    NSDictionary *parameter = @{
                                @"phone":phone,
                                @"password":password,
                                @"verifyCode":verifyCode,
                                @"inviteCode":inviteCode,
                                @"deviceId":uuid,
                                @"blackbox":FMDeviceManager.sharedManager->getDeviceInfo(),
                                @"deviceExtra":[HHDeviceUtils  deviceExtra],
                                @"appExtra":[HHDeviceUtils  appExtra]
                                };
    [HHNetworkManager postRequestWithUrl:k_register_url parameters:parameter isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHUserModel *user = [HHUserModel mj_objectWithKeyValues:dict];
            
            if (user.statusCode == 200) {
                [HHUserManager sharedInstance].currentUser  = user;
                handler(nil,user.msg);
            } else {
                handler(user.msg,nil);
            }
        } else {
            handler(error,nil);
        }
        
    }];
    
}

+ (void)changePasswordWithOldPas:(NSString *)oldPassword
                    newPassword:(NSString *)newPassword
                         handler:(void(^)(id error, NSString *response))handler {
    
    NSDictionary *parameter = @{
                                @"oldPassword":oldPassword,
                                @"newPassword":newPassword,
                                };
    
    [HHNetworkManager postRequestWithUrl:k_update_password parameters:parameter isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHResponse *response = [HHResponse mj_objectWithKeyValues:dict];
            
            if (response.statusCode == 200) {
                
                handler(nil,response.msg);
            } else {
                handler(response.msg,nil);
            }
        } else {
            handler(error,nil);
        }
        
    }];
    
}


+ (void)authorizeWeixinWithCode:(NSString *)code
                       callback:(void(^)(id error , HHWeixinAccount *account))callback{
    NSDictionary *parameters = @{
                                 @"code":code
                                 };
    NSDictionary *otherArg = @{@"appendUserInfo":@1};
    [HHNetworkManager postRequestWithUrl:k_authorize_wx parameters:parameters isEncryptedJson:YES otherArg:otherArg handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            callback(error,nil);
        } else {
            HHWeixinAuthorizedResponse *response = [HHWeixinAuthorizedResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];

            
            if (response.statusCode == 200) {
                HHWeixinAccount *weixinAccount = [HHWeixinAccount mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
                callback(nil, weixinAccount);
            } else {
                callback(response.msg,nil);
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
                                 @"blackbox":FMDeviceManager.sharedManager->getDeviceInfo(),
                                 @"deviceExtra":[HHDeviceUtils deviceExtra],
                                 @"appExtra":[HHDeviceUtils appExtra]
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
    
    [HHNetworkManager postRequestWithUrl:k_readConfig_url parameters:nil isEncryptedJson:NO otherArg:@{@"requestType" : @"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHReadConfigResponse *readConfig = [HHReadConfigResponse mj_objectWithKeyValues:dict[@"readConfig"]];
            [[HHUserManager sharedInstance] setReadConfig:readConfig];
            
        } else {
            Log(error);
        }
        
    }];
    
}

+ (void)requestBSJson:(void(^)(BOOL bs))callback {
    
    __block BOOL result = NO;
    
//    BOOL firstLoad = [(AppDelegate *)UIApplication.sharedApplication.delegate firstLoad];
    ///写入version 下次判断升级用户
    NSLog(@"%zd", [(AppDelegate *)UIApplication.sharedApplication.delegate isFirstLoadOrUpdate]);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"CFBundleShortVersionString"];
    [HHNetworkManager GET:[NSString stringWithFormat:@"http://file.cashtoutiao.com/package/ios/%@.json", version] parameters:nil handler:^(id err, id res) {
        
        @try {
            if (res) {
                
#ifdef DEBUG
                
                
#else
                
                 result = [[[res mj_JSONObject] objectForKey:@"simplified"] boolValue];
#endif
               
            }
            
        } @catch (NSException *exception) {
            
        } @finally {
            
            G.$.bs = result;
            callback(result);
        }
        
    }];
    
    
    
}




@end

//
//  HHLoginNetwork.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 public static final short REGISTER = 1;
 public static final short RETRIEVE_PASSWORD = 2;
 
 public static final short BIND_PHONE = 3;
 
 public static final short BIND_PHONE_AGAIN = 4;
 
 public static final short ACCOUNT_PASSWORD = 5;
 */

typedef enum : NSUInteger {
    SendSmsTypeREGISTER = 1,
    SendSmsTypeRETRIEVE_PASSWORD = 2,
    SendSmsTypeBIND_PHONE = 3,
    SendSmsTypeBIND_PHONE_AGAIN = 4,
    SendSmsTypeACCOUNT_PASSWORD = 5
} SendSmsType;

@interface HHLoginNetwork : NSObject



+ (void)checkLogin:(void(^)(id error , NSString * result))callback;
///登陆
+ (void)loginRequestWithPhone:(NSString *)phone
                     password:(NSString *)password
                      handler:(void(^)(NSString *respondsStr, id error))handler;
///注册
+ (void)registWithPhone:(NSString *)phone
               password:(NSString *)password
             verifyCode:(NSString *)verifyCode
             inviteCode:(NSString *)inviteCode
                handler:(void(^)(id error, NSString *response))handler;

+ (void)changePasswordWithOldPas:(NSString *)oldPassword
                     newPassword:(NSString *)newPassword
                         handler:(void(^)(id error, NSString *response))handler;
///第三方登录
+ (void)loginRequstByThirdPartyType:(NSInteger)type
                               code:(NSString *)code
                           callback:(void(^)(id error , id result))callback ;
///微信授权
+ (void)authorizeWeixinWithCode:(NSString *)code
                       callback:(void(^)(id error , HHWeixinAccount *account))callback;

///获取验证码 type 
+ (void)sendSms:(NSString *)phone
           type:(SendSmsType)type
        handler:(void(^)(NSString *msg, id error))handler;
///请求阅读收益规则
+ (void)requestReadConfig;



@end

//
//  AlipayService.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/3.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "AlipayService.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AlipaySDK/APayAuthInfo.h>
#import "APAuthInfo.h"
#import "APRSASigner.h"
#import "HHDeviceUtils.h"
#import "HHUserModel.h"


@interface AlipayService ()

typedef void (^alipayHandler)(id error,id result);

@property (nonatomic,copy)alipayHandler handler;

@end

static NSString *privateKey = nil;

static AlipayService *ali = nil;

@implementation AlipayService



+ (void)load {
    
    ali = [AlipayService new];
    
}

+ (AlipayService *)sharedAlipay {
    
    return ali;
    
}

#define APPID @"2017052007296690"
#define PID @"2088121024445276"
#define TARGET_ID UUID

- (void)loginToAli:(void(^)(id error , id result))callback {
    
    self.handler = callback;
    
    [self getRSA2Private:^(id error, NSString *rsa2PrivateKey) {
        
        if (rsa2PrivateKey) {
            
            APAuthInfo *authInfo = [APAuthInfo new];
            authInfo.pid = PID;
            authInfo.appID = APPID;
            NSString *appScheme = @"HuiHeadline";
            NSString *authInfoStr = [authInfo description];
            
            NSString *signedString = nil;
            APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:rsa2PrivateKey];
            if ((rsa2PrivateKey.length > 1)) {
                signedString = [signer signString:authInfoStr withRSA2:YES];
            } else {
                signedString = [signer signString:authInfoStr withRSA2:NO];
            }
            authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA2"];

            
            [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                             fromScheme:appScheme
                                               callback:^(NSDictionary *resultDic) {
                   //网页授权 走这个接口
                   NSLog(@"result = %@",resultDic);
                   // 解析 auth code
                   NSString *result = resultDic[@"result"];
                   NSString *authCode = nil;
                   if (result.length>0) {
                       NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                       for (NSString *subResult in resultArr) {
                           if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                               authCode = [subResult substringFromIndex:10];
                               break;
                           }
                       }
                   }
                   if (authCode) {
                       
                       [self loginCashToutiaoAliWithAuthCode:authCode];
                       
                   } else {
                       
                       [HHHeadlineAwardHUD showMessage:@"支付宝授权失败" animated:YES duration:2];
                   }
               }];
            
        }
    }];
   
}

- (void)processAuth_V2Result:(NSURL *)url {
    
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        if (authCode) {
            
            [self loginCashToutiaoAliWithAuthCode:authCode];
            
        } else {
            
            [HHHeadlineAwardHUD showMessage:@"支付宝授权失败" animated:YES duration:2];
        }
    }];
    
}

- (void)loginCashToutiaoAliWithAuthCode:(NSString *)authCode {
    
    
    [HHLoginNetwork loginRequstByThirdPartyType:0 code:authCode callback:self.handler];
    
}






- (void)getRSA2Private:(void(^)(id error , NSString *private))callback{
    
    [HHNetworkManager postRequestWithUrl:k_login_ali_secret parameters:@{} isEncryptedJson:YES otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            if ([[[respondsStr mj_JSONObject] objectForKey:@"statusCode"] integerValue] == 200) {
                callback(nil, [[respondsStr mj_JSONObject] objectForKey:@"criticalValue"]);
            } else {
                callback(nil,[respondsStr mj_JSONObject]);
            }
        }
        
    }];
}



@end

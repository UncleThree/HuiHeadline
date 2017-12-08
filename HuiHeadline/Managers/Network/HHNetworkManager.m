//
//  HHNetworkManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHNetworkManager.h"
#import "HHLoginViewController.h"

static UIAlertController *alert = nil;

static UIViewController *currentVC = nil;

@implementation HHNetworkManager

+ (void)GET:(NSString *)url
 parameters:(id)parameters
    handler:(void(^)(id error, id result))handler
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(nil,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(error,nil);
    }];
}


//options
//requestType : json
//appendUserInfo url拼接userId loginId 参数传入 userId loginId
//appendUserInfoNotParamaters  url拼接userId loginId

+ (void)postRequestWithUrl:(NSString *)url
                parameters:(id)parameters
           isEncryptedJson:(BOOL)isEncryptedJson
                  otherArg:(NSDictionary *)options
                   handler:(void(^)(NSString *respondsStr, NSError *error))handler

{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (isEncryptedJson) {
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer
         setValue:@"application/encrypted-json"
         forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer
         setValue:@"application/encrypted-json"
         forHTTPHeaderField:@"Content-Type"];
        
    }  else {
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    BOOL CheckLogin = NO;
    if (options) {
        
        if (options[@"CheckLogin"]) {
            CheckLogin = [options[@"CheckLogin"] boolValue];
        }
        if (options[@"requestType"] && [options[@"requestType"] isEqualToString:@"json"] && !isEncryptedJson) {
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
        }
        if (options[@"Content-Type"]) {
            
            [manager.requestSerializer setValue:options[@"Content-Type"] forHTTPHeaderField:@"Content-Type"];
        }
        if (options[@"Accept"]) {
            
            [manager.requestSerializer setValue:options[@"Accept"] forHTTPHeaderField:@"Accept"];
        }
        
    }
    
    NSNumber *userId = [NSNumber numberWithLong:HHUserManager.sharedInstance.userId];
    NSString *loginId = HHUserManager.sharedInstance.loginId;
    if (userId && loginId) {
        
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?userId=%@&loginId=%@&appVersion=%@", userId, loginId, APP_VER]];
        NSMutableDictionary *dict = parameters ? [(NSDictionary *)parameters mutableCopy] : [NSMutableDictionary dictionary];
        [dict setObject:userId forKey:@"userId"];
        [dict setObject:loginId forKey:@"loginId"];
        parameters = dict.copy;
        
    }
    NSMutableDictionary *dict = parameters ? [(NSDictionary *)parameters mutableCopy] : [NSMutableDictionary dictionary];
    [dict setObject:@(1) forKey:@"platform"];
    [dict setObject:[NSNumber numberWithInt:[APP_VER intValue]] forKey:@"appVersion"];
    parameters = dict.copy;
    
    if (isEncryptedJson) {
        //字典转为json
        if (!parameters) {
            return;
        } else if (![parameters isKindOfClass:[NSDictionary class]]) {
            NSLog(@"加密参数需要字典类型! parameters:%@", parameters);
            return;
        }
        NSString *json = [parameters mj_JSONString];
        //json加密为data
        parameters = [HHSecurityManager encryptWithString:json];
        
        
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            //解密成json字符串 / utf8字符串
            NSString *jsonResult = isEncryptedJson ? [HHSecurityManager decryptWithData:responseObject] : [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            handler(jsonResult,nil);
        } else {
            NSLog(@"post request responseObject is not kind of class of NSData!!! : %@", responseObject);
            NSError *error = [NSError errorWithDomain:@"Not data responseObject" code:999 userInfo:nil];
            handler(nil, error);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.description && [error.description containsString:@"似乎已断开与互联网的连接"]) {
            
            [HHHeadlineAwardHUD showMessage:@"请检查网络连接！" animated:YES duration:2];
        } else if (error.description && [error.description containsString:@"unauthorized"] && !CheckLogin) {
            
            [self alertUnaithorized];
        }
        
        handler(nil, error);
        
    }];
}

+ (void)alertUnaithorized {
    
    
    [HHHeadlineAwardHUD showLoginErrorViewWithTarget:self action:@selector(login)];
   
    
}

+ (void)login {
    
    UIApplication.sharedApplication.delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
    
}







@end

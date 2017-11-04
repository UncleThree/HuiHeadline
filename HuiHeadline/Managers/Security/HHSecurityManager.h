//
//  HHSecurityManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

//POST参数加密类
@interface HHSecurityManager : NSObject

///将JSON字符串加密成data
+ (NSData *)encryptWithString:(NSString *)text;
///将data解密为JSON字符串
+ (NSString *)decryptWithData:(NSData *)data;

@end

//获取新闻的key加密类
@interface HHEncryptionManager : NSObject

+ (NSString *)encryptWithCode:(NSString *)code
                     joinCode:(NSString *)joinCode;

@end

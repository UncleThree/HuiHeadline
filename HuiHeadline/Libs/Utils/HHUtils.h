//
//  HHUtils.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUtils : NSObject

///每隔三位插入一个逗号
+ (NSString *)insertComma:(NSString *)num;

+ (BOOL)isMobileNumber:(NSString *)str;

+ (BOOL)isEmailAddress:(NSString *)str;

+ (BOOL)isOnlyChinese:(NSString *)str;

+ (BOOL)isNameValid:(NSString *)name;

//+ ( float )readCacheSize;

+ (NSString *)getSDCacheSize ;

+ (void)clearFile:(void(^)(NSString *cache))callback;
    
@end

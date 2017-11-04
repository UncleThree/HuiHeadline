//
//  EntryNeed.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryNeed : NSObject
//获取3位整数：第一位代表从左向右取几位，第二位代表从右向左取几位 第三决定后面and/add/or/reduce
+ (NSArray <NSNumber *>*)shortKey:(NSString *)shortKey;

+ (NSString *)getTail:(NSString *)str
             position:(NSUInteger)position;

+ (NSString *)and:(NSString *)_left
                 :(NSString *)_right;

+ (NSString *)add:(NSString *)_left
                 :(NSString *)_right;

+ (NSString *)or:(NSString *)_left
                 :(NSString *)_right;

+ (NSString *)reduce:(NSString *)_left
                    :(NSString *)_right;

+ (NSString *)stringWithHexNumber:(int)hexNumber;

@end

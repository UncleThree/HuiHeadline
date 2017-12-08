//
//  HHTimeUtil.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHDateUtil : NSObject

+ (NSString *)timeFormatter:(NSTimeInterval)_date;

+ (int)paseDays:(long)day;

+ (long)beforeDays:(long)time;
///得到现在是几点
+ (int)formatterHour ;
///1900-01-01 00:00:00
+ (NSString *)detailTimeFormat:(long)interval;

+ (NSString *)ymd:(long)interval;

//like this : @[@"1900年01月01日",@"下午00:00",@"2"]
+ (NSArray *)incomeDetailTimerFormatter:(long)time;

+ (NSString *)today;

+ (NSString *)creditTimeFormat:(long)time;

///01月01日 12：12
+ (NSString *)invitedTime:(long)time;

@end

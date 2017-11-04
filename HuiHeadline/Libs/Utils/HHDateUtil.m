//
//  HHTimeUtil.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHDateUtil.h"

@implementation HHDateUtil

///0今天 1昨天 2前天
+ (int)paseDays:(long)day {
    if (!day) {
        return -1;
    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString *currentDay = [formatter stringFromDate:currentDate];
    NSString *dayString = [NSString stringWithFormat:@"%ld", day];
    dayString = [dayString substringFromIndex:dayString.length - 2];
    return [currentDay intValue] - [dayString intValue] ;
}


+ (long)beforeDays:(long)time {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSDate *dateToday = [formatter dateFromString:strDate];
    NSTimeInterval timeToday = [dateToday timeIntervalSince1970]; // 这个就是今天0点的那个秒点整数了
    long persecond = 60 * 60 * 24;
    long pastToday = timeToday - time / 1000;
    long pastDays = (long)ceilf((float)pastToday / (float)persecond) ;//向上取整
    return pastDays;
    
}

+ (NSString *)timeFormatter:(NSTimeInterval)_date {
    
    @autoreleasepool {
        
        
        NSDate *currentDate = [NSDate date];
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        
        if ([[NSString stringWithFormat:@"%f",_date] componentsSeparatedByString:@"."][0].length > [[NSString stringWithFormat:@"%f",currentTimeInterval] componentsSeparatedByString:@"."][0].length) {
            ///ms s
            _date = _date / 1000.0;

        }
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:_date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:date];
        NSString *currentYear = [formatter stringFromDate:currentDate];
        [formatter setDateFormat:@"MM"];
        NSString *month= [formatter stringFromDate:date];
        if (month.length == 1) {
            month = [@"0" stringByAppendingString:month];  //09月
        }
        [formatter setDateFormat:@"dd"];
        NSString *day= [formatter stringFromDate:date];
        
        NSString *timeStr = nil;
        //过去多少分钟
        long past = (long)(currentTimeInterval - _date) / 60;
        
        if (past < 1) {
            timeStr = @"刚刚";
        } else if (past >= 1 && past < 60) {
            timeStr = [NSString stringWithFormat:@"%ld分钟前", past];
        } else if (past >= 60 && past < 24 * 60) {
            timeStr = [NSString stringWithFormat:@"%ld小时前", past / 60];
        }
        //没有几天前
        //    else if (past > 60 * 24 && past <= 60 * 24 * 30) {
        //        timeStr = [NSString stringWithFormat:@"%ld天前", past / 60];
        //    }
        else if ([year isEqualToString:currentYear]) {
            timeStr = [NSString stringWithFormat:@"%@月%@日",month, day];
        } else {
            timeStr = [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
        }
        return timeStr;
    }
    
}

+ (int)formatterHour {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *hour = [formatter stringFromDate:currentDate];
    int intHour = [hour intValue];
    return intHour;
}

+ (NSString *)detailTimeFormat:(long)interval {
    
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:interval / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    return time;
    
}

+ (NSArray *)incomeDetailTimerFormatter:(long)time {
    
    @autoreleasepool {
        
        NSDate *currentDate = [NSDate date];
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:time / 1000];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:date];
        NSString *currentYear = [formatter stringFromDate:currentDate];
        [formatter setDateFormat:@"MM"];
        NSString *month= [formatter stringFromDate:date];
        if (month.length == 1) {
            month = [@"0" stringByAppendingString:month];  //09月
        }
        [formatter setDateFormat:@"dd"];
        NSString *day= [formatter stringFromDate:date];
        
        [formatter setDateFormat:@"ahh:mm"];
        NSString *detail = [[[formatter stringFromDate:date] stringByReplacingOccurrencesOfString:@"PM" withString:@"下午"] stringByReplacingOccurrencesOfString:@"AM" withString:@"上午"];
        
        
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *strDate = [formatter stringFromDate:[NSDate date]];
        NSDate *dateToday = [formatter dateFromString:strDate];
        NSTimeInterval timeToday = [dateToday timeIntervalSince1970]; // 这个就是今天0点的那个秒点整数了
        
        NSString *timeStr = nil;
        //过去多少分钟
        long past = (long)(currentTimeInterval - time / 1000) / 60;
        long persecond = 60 * 60 * 24;
        long pastToday = timeToday - time / 1000;
        long pastDays = (long)ceilf((float)pastToday / (float)persecond) ;//向上取整
        if (past < 1) {
            timeStr = @"今天&刚刚";
        } else if (pastDays == 0 && past >= 1 && past < 60) {
            timeStr = [NSString stringWithFormat:@"今天&%ld分钟前", past];
        } else if (pastDays == 0 && past >= 60 ) {
            timeStr = [NSString stringWithFormat:@"今天&%@", detail];
        } else if (pastDays == 1) {
            timeStr = [NSString stringWithFormat:@"昨天&%@", detail];
            
        } else if (pastDays == 2) {
            timeStr = [NSString stringWithFormat:@"前天&%@", detail];
            
        } else if ([year isEqualToString:currentYear]) {
            
            timeStr = [NSString stringWithFormat:@"%@月%@日&%@",month, day,detail];
        } else {
            timeStr = [NSString stringWithFormat:@"%@年%@月%@日&%@", year, month, day,detail];
        }
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"&%ld", pastDays]];
        return [timeStr componentsSeparatedByString:@"&"];
    }
}



@end

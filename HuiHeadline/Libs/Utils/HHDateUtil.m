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
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today =  [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate *yesterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:- secondsPerDay];
    NSDate *beforeyesterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:- 2 *secondsPerDay];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    
    NSDateFormatter *myformatter = [[NSDateFormatter alloc] init];
    myformatter.dateFormat = @"yyyymmdd";
    NSDate *myDate = [myformatter dateFromString:[NSString stringWithFormat:@"%ld",day]];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:myDate];
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:today];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yesterDay];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:beforeyesterDay];
    
    if ( comp.day == comp2.day) {
        return 1;
    } else if ( comp.day == comp3.day) {
        
        return 2;
    } else if (comp.day == comp1.day) {
        return 0;
    } else {
        return -1;
    }
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


+ (NSString *)today {

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
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



+ (NSString *)creditTimeFormat:(long)time {
    
    @autoreleasepool {
        
        NSDate *currentDate = [NSDate date];
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
        
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
            timeStr = @"刚刚";
        } else if (pastDays == 0 && past >= 1 && past < 60) {
            timeStr = [NSString stringWithFormat:@"%ld分钟前", past];
        } else if (pastDays == 0 && past >= 60 ) {
            long hour = past / 60;
            timeStr = [NSString stringWithFormat:@"%zd小时前", hour];
        } else if (pastDays < 30) {
            timeStr = [NSString stringWithFormat:@"%zd天前", pastDays];
            
        } else if (pastDays >= 30 && [year isEqualToString:currentYear]) {
            long pastMonth = pastDays / 30;
            timeStr = [NSString stringWithFormat:@"%zd月前", pastMonth];
            
        } else {
            timeStr = [NSString stringWithFormat:@"%@年%@月%@日&%@", year, month, day,detail];
        }
       
        return timeStr;
    }
    
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


+ (NSString *)invitedTime:(long)time {
    
    NSDate *currentDate = [NSDate date];
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
    [formatter setDateFormat:@"hh:mm"];
    NSString *detail = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyyMMdd"];

    NSString *timeStr = nil;

    if ([year isEqualToString:currentYear]) {
        
        timeStr = [NSString stringWithFormat:@"%@月%@日 %@",month, day,detail];
    } else {
        timeStr = [NSString stringWithFormat:@"%@年%@月%@日 %@", year, month, day,detail];
    }
    return timeStr;
    
}


@end

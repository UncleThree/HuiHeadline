//
//  HHUserDailyTaskResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserDailyTaskResponse.h"

@implementation HHUserDailyTaskResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"activityTaskList":@"HHUserActivityTask",
             @"dailyTaskList":@"HHUserDailyTask",
             @"dynamicTaskList":@"HHUserDynamicTask"
             
             };
    
}

@end

@implementation HHUserDailyTask

- (NSString *)taskDescription {
    if (_taskId >= 1 && _taskId <= 6) {
        return  @[@"",@"邀请收徒",@"新闻分享",@"分享到朋友圈收徒",@"分享到微信群收徒",@"阅读资讯5分钟",@"观看视频5分钟"][_taskId];
    }
    return nil;
    
}

- (NSString *)taskRewardDescription {
    if (_taskId >= 1 && _taskId <= 6) {
        return  @[@"",@"每收一名徒弟即可获得高额金币奖励，徒弟阅读文章还会向您进贡额外金币奖励",@"阅读资讯分享新闻，好友点击后，即可获得该任务奖励",@"该奖励为分享收徒福利，需分享到朋友圈里，且被好友认真阅读了才能拿到奖励",@"该奖励为分享收徒福利，需分享到微信群里，且被群友认真阅读了才能拿到奖励",@"每天阅读资讯可获得额外奖励",@"进入视频详情页（每个视频下的白色区域），观看视频可获得额外奖励"][_taskId];
    }
    return nil;
    
}

- (NSString *)btnDes {
    
    if (self.taskDescription) {
        
        if ([self.taskDescription containsString:@"阅读"]) {
            return @"立即阅读";
        } else if ([self.taskDescription containsString:@"观看"]) {
            return @"立即观看";
        }  else if ([self.taskDescription containsString:@"收徒"]) {
            return @"立即收徒";
        } else if ([self.taskDescription containsString:@"分享"]) {
            return @"立即收徒";
        }  else {
            NSLog(@"WTF");
        }
    }
    return nil;
}


@end

@implementation HHUserActivityTask

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"Description":@"description"
             };
}



@end

@implementation HHUserDynamicTask 

@end

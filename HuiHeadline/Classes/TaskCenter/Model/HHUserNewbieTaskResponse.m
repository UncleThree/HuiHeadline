//
//  HHUserNewbieTaskList.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserNewbieTaskResponse.h"

@implementation HHUserNewbieTask

- (NSString *)taskDescription {
    
    if (_taskId < 1 || _taskId > 6) {
        return nil;
    } else {
        return [@[@"绑定手机号",@"绑定微信",@"阅读资讯1分钟",@"观看视频一分钟",@"提现1元到支付宝",@"首次收徒"] objectAtIndex:_taskId - 1];
    }
}

- (NSString *)taskButtonDes {
    
    if (self.taskDescription) {
        if ([self.taskDescription containsString:@"绑定"]) {
            return @"立即绑定";
        } else if ([self.taskDescription containsString:@"阅读"]) {
            return @"立即阅读";
        } else if ([self.taskDescription containsString:@"观看"]) {
            return @"立即观看";
        } else if ([self.taskDescription containsString:@"提现"]) {
            return @"立即提现";
        } else if ([self.taskDescription containsString:@"收徒"]) {
            return @"立即收徒";
        } else {
            NSLog(@"WTF");
        }
    }
    return nil;
    
}

- (NSString *)taskRewardDescription {
    
    if (_taskId < 1 || _taskId > 6) {
        return nil;
    } else {
        return [@[@"绑定手机号可立即获得奖励",@"绑定微信可获得奖励",@"阅读文章1分钟可获得奖励",@"进入视频详情页(每个视频下的白色区域),观看视频一分钟可获得奖励",@"完成以上4个任务，将获得2000金币，可立即提现到支付宝",@"首次成功收徒的额外奖励"] objectAtIndex:_taskId - 1];
    }
}

@end

@implementation HHUserNewbieTaskResponse


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"newbieTaskList":@"HHUserNewbieTask"
             };
}

@end



//
//  HHTaskCenterNetwork.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHSignRecordResponse.h"
#import "HHSignResponse.h"
#import "HHUserNewbieTaskResponse.h"
#import "HHUserDailyTaskResponse.h"
#import "HHUserDrawTaskRewardResponse.h"
#import "HHBannerResponse.h"

@interface HHTaskCenterNetwork : NSObject

+ (void)requestForSignNotificationList:(Block)callback;

+ (void)requestForSignRecord:(void(^)(id error, HHSignRecordResponse *response))callback;

+ (void)sign:(void(^)(id error, HHSignResponse *response))callback;

+ (void)requstNewBieTaskList:(void(^)(id error,NSArray<HHUserNewbieTask *> *tasks))callback;

+ (void)requestDailyTaskList:(void(^)(id error,HHUserDailyTaskResponse *response))callback;

+ (void)drawTaskReward:(BOOL)isNewBie
                taskId:(NSInteger)taskId
              callback:(void(^)(id error, HHUserDrawTaskRewardResponse *response))callback;

+ (void)dailyTaskCompleted:(NSInteger)taskId
                  callback:(void(^)(id error, HHResponse *response))callback;

+ (void)getBannerInfoWithPosition:(NSInteger)position
                         callback:(void(^)(id error, BannerInfo *bannerInfo))callback;

@end

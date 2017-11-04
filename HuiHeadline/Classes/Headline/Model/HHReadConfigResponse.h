//
//  HHReadConfig.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/11.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHReadConfigResponse : NSObject


///新闻多少s提交一次奖励
@property (nonatomic)NSInteger durations;
///每次提交多少金币
@property (nonatomic)NSInteger creditPerDurations;
///每次分享多少金币
@property (nonatomic)NSInteger shareClickCreditPerTimes;
///超出 时间 -- 累计一小时额外给奖励
@property (nonatomic)NSInteger exceedDurations;
///超出时间额外奖励
@property (nonatomic)NSInteger exceedDurationsExtraCredit;
///
@property (nonatomic)NSInteger exceedShareClick;
@property (nonatomic)NSInteger exceedShareClickExtraCredit;
///
@property (nonatomic)NSInteger sychExposureAdIntervalSeconds;
///视频多少s提交
@property (nonatomic)NSInteger videoDurations;
///视频每次提交奖励金币
@property (nonatomic)NSInteger creditPerVideoDurations;
///最大视频时间
@property (nonatomic)int maxSychVideoDuration;
//每个新闻最多计时多少s
@property (nonatomic)int maxSecondsPerNews;
//
@property (nonatomic)int maxKeepTaskTimes;
///每次最大广告曝光数
@property (nonatomic)NSInteger maxSychExposureAdNumberPerTime;
@end

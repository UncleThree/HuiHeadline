//
//  HHUserManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHUserModel.h"
#import "HHReadConfigResponse.h"
#import "HHReadSychDurationResponse.h"
#import "HHCreditSummaryResponse.h"
#import "HHSignRecordResponse.h"
#import "HHUserNewbieTaskResponse.h"
#import "HHUserDailyTaskResponse.h"
#import "HHAlipayAccountResponse.h"
#import "HHWeixinAccountResponse.h"
#import "HHProductIndoResponse.h"
#import "HHBannerResponse.h"

@interface HHUserManager : NSObject

@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *passWord;

///阅读奖励的引导图是否被点击过
@property (nonatomic, assign)BOOL hasClick;

///当前用户
@property (nonatomic, strong)HHUserModel *currentUser;
///当前奖励规则 每次启动程序重新获取
@property (nonatomic, strong)HHReadConfigResponse *readConfig;
///同步阅读时长 用来记录每次的token和virifyCode
@property (nonatomic, strong)HHReadSychDurationResponse *sychDurationResponse;
///今日金币 剩余金币 总金币
@property (nonatomic, strong)HHUserCreditSummary *creditSummary;
///签到信息
@property (nonatomic, strong)HHSignRecordResponse *signRecordResponse;
///新手任务列表
@property (nonatomic, strong)NSArray<HHUserNewbieTask *> *newbieTasks;
///日常任务
@property (nonatomic, strong)HHUserDailyTaskResponse *dailyTaskResponse;
///taskBanner
@property (nonatomic, strong)BannerInfo *taskBannerInfo;

@property (nonatomic, strong)NSArray<HHProductOutline *> *products;
///alipayAccount
@property (nonatomic, strong)HHAlipayAccount *alipayAccount;
///weixinAccount
@property (nonatomic, strong)HHWeixinAccount *weixinAccount;

@property (nonatomic, strong)NSString *today;

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)NSTimer *videoTimer;

@property (nonatomic, assign)int lastPerHourAwardTime;

@property (nonatomic, assign)int readTime;

@property (nonatomic, assign)int videoTime;

@property (nonatomic, assign)int virifyCodeCountdown;

@property (nonatomic, assign)NSTimeInterval lastSychAdTime;
///每次同步用户阅读的文章数
@property (nonatomic, assign)int newsCount;

//当前用户对应的频道列表
@property (nonatomic, strong)NSMutableArray<NSString *> *channels;
//所有channel
@property (nonatomic, strong)NSMutableArray<NSString *> *allChannels;

//当前用户对应的频道列表
@property (nonatomic, strong)NSMutableArray<NSString *> *video_channels;
//所有channel
@property (nonatomic, strong)NSMutableArray<NSString *> *vodeo_allChannels;

///已经获得过奖励的广告channel
@property (nonatomic, strong)NSMutableArray<NSString *> *awardedAdChannels;

+ (instancetype)sharedInstance;

@property (nonatomic, assign)long userId;

@property (nonatomic, copy)NSString *loginId;





@end

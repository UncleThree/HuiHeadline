//
//  HHHeadlineNetwork.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAwardPerHourResponse.h"
#import "HHAdModel.h"
#import "HHReadAnalyseUtil.h"

//typedef void(^Block)(NSError *error,id result);

@interface HHHeadlineNetwork : NSObject
///请求新闻列表
+ (void)requestForNewsWithType:(NSString *)type
                       isFirst:(BOOL)isFirst
                       refresh:(BOOL)refresh //是否是下拉加载
                       handler:(Block)handler;
///请求置顶新闻列表
+ (void)requestForTopNews:(Block)callback;
///请求广告列表
+ (void)requestForAdList:(Block)callback;
///请求banner广告列表
+ (void)requestForBannerAdList:(Block)callback;
///请求阅读奖励
+ (void)requestForReadAward:(Block)callback;
///请求三天内的奖励数据
+ (void)requestForReadIncomeDetail:(Block)callback;
///同步时段奖励
+ (void)sychRewardPerHourWithHour:(int)hour
                         callback:(void(^)(NSError *error,HHAwardPerHourResponse *response))callback;
///同步阅读时长
+ (void)sychDurationWithDuration:(int)duration
                           count:(int)count
                      actionInfo:(AntifraudReadActionInfo *)actionInfo
                        callback:(Block)callback ;
///同步视频时长
+ (void)sychVideoDurationWithDuration:(int)duration
                             callback:(void(^)(id error , HHReadSychDurationResponse *response))callback;

///同步广告曝光
/// 五个广告/超过2分钟曝光一次 
+ (void)sychListAdExposureWithMap:(NSDictionary<NSString *,NSNumber *> *)map
                         callback:(void(^)(id error, HHResponse *response))callback;


@end

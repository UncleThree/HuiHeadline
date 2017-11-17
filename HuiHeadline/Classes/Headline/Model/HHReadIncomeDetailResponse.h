//
//  HHReadIncomeDetailResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/11.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HHReadIncomDetailRecord;

@interface HHReadIncomeDetailResponse : NSObject


@property (nonatomic, strong)NSMutableArray<HHReadIncomDetailRecord *> *records;


@end

@interface HHReadIncomDetailRecord : NSObject

///日期
@property (nonatomic)int day;

@property (nonatomic)int pastDay;
///阅读时长
@property (nonatomic)int duration;
///阅读获得积分
@property (nonatomic)int durationCredit;
///分享点击数
@property (nonatomic)int shareClick;
///分享获得积分
@property (nonatomic)int shareClickCredit;
///做任务获得积分
@property (nonatomic)int taskCredit;
///看视频时长
@property (nonatomic)int videoDuration;
///看视频获得积分
@property (nonatomic)int videoDurationCredit;

- (CGFloat)heightForCell ;


@end

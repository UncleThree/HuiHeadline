//
//  HHTaskCellModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHTaskCellModel : NSObject

@property (nonatomic, assign)HHUserNewbieTaskType taskId;

@property (nonatomic, assign)HHUSerDailyTaskType dailyTaskId;

@property (nonatomic, copy)NSString *title;
///0未做 1已做 2已完成
@property (nonatomic, assign)NSInteger state;
///立即绑定 立即领取
@property (nonatomic, copy)NSString *subText;

@property (nonatomic, assign)BOOL show;
///activityTask url
@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *activityTitle;

@property (nonatomic, assign)BOOL visit;

- (CGFloat)heightForModel;

@end

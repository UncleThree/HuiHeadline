//
//  HHUserNewbieTaskList.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

typedef enum : NSUInteger {
    
    BIND_PHONE = 1,
    BIND_WEIXIN = 2,
    READ_ONE = 3,
    VIDEO_ONE = 4,
    WITHDRAW_CASH = 5,
    FIRST_APPRENTICE = 6
    
} HHUserNewbieTaskType;


@interface HHUserNewbieTask : NSObject

@property (nonatomic, assign)NSInteger reward;
///0未做 1已做 2已完成
@property (nonatomic, assign)NSInteger state;

@property (nonatomic, assign)HHUserNewbieTaskType taskId;

@property (nonatomic, strong)NSString *taskDescription;

@property (nonatomic, strong)NSString *taskRewardDescription;
///立即绑定 立即阅读 等
@property (nonatomic, strong)NSString *taskButtonDes;

@end

@interface HHUserNewbieTaskResponse : HHResponse

@property (nonatomic, strong)NSArray<HHUserNewbieTask *> *newbieTaskList;

@end

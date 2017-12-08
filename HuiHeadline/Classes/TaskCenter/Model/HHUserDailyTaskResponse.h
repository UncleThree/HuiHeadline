//
//  HHUserDailyTaskResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

typedef enum : NSUInteger {
    INVITE_APPRENTICE = 1,  //(首次收徒)
    NEWS_SHARE = 2,         //(新闻分享)
    SHARE_FRIEND_CIRCLE = 3,//(分享朋友圈)
    SHARE_WEIXIN_GROUP = 4, //(分享微信群)
    READ_FIVE = 5,          //(阅读资讯5分钟)
    VIDEO_FIVE = 6,         //(观看视频5分钟)
    READ_EXPRESS = 7,       //(暂时没用)
    SEARCH_TASK = 8,        //(搜索任务)
    GAME_TASK = 9,          //游戏任务
    AD_LIST_101 = 101,      //(动态任务)
    
} HHUSerDailyTaskType;

@interface HHUserDailyTask : NSObject

@property (nonatomic)NSInteger reward;
@property (nonatomic)NSInteger state;
@property (nonatomic)NSInteger taskId;

@property (nonatomic, copy)NSString *taskDescription;

@property (nonatomic, copy)NSString *taskRewardDescription;

@property (nonatomic, copy)NSString *btnDes;

@property (nonatomic, assign)BOOL visit;

@end

@interface HHUserActivityTask : NSObject

@property (nonatomic, copy)NSString *buttonDes;

@property (nonatomic, copy)NSString *Description;

@property (nonatomic, copy)NSString *rewardDes;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *url;

@property (nonatomic)NSUInteger order;

@property (nonatomic, assign)BOOL visit;

@end

@interface HHUserDynamicTask : NSObject

@property (nonatomic)NSInteger Id;

@property (nonatomic)NSUInteger experienceTime;

@property (nonatomic, copy)NSString *buttonDes;

@property (nonatomic, copy)NSString *rewardDes;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *url;

@property (nonatomic, assign)BOOL visit;




@end

@interface HHUserDailyTaskResponse : HHResponse

@property (nonatomic, strong)NSMutableArray<HHUserActivityTask *> *activityTaskList;

@property (nonatomic, strong)NSMutableArray<HHUserDailyTask *> *dailyTaskList;

@property (nonatomic, strong)NSMutableArray<HHUserDynamicTask *> *dynamicTaskList;

@end

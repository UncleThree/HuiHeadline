//
//  HHTaskSectionHeaderModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHTaskSectionHeaderModel : NSObject

@property (nonatomic, assign)HHUserNewbieTaskType taskId;

@property (nonatomic, assign)HHUSerDailyTaskType dailyTaskId;
///1 top 2normal 3bottom
@property (nonatomic,assign)int type;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *reward;

///是否已经完成
@property (nonatomic,assign)BOOL completed;

///YES则为红包图片 否则是金币图片
@property (nonatomic,assign)BOOL isRedPaper;

@property (nonatomic,assign)BOOL open;

@end

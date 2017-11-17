//
//  AdStrategyManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAdStrategy.h"

@interface AdStrategyManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong)HHAdStrategy *adStrategey;

@property (nonatomic, strong)HHAdStrategy *shortedAdStrategey;

@property (nonatomic, strong)HHAdStrategy *bannerAdStrategey;
///同步策略时间 s
@property (nonatomic, assign)double lastTime;


@end

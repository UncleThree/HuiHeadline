//
//  AdStrategyManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "AdStrategyManager.h"



@implementation AdStrategyManager

//@synthesize adStrategey = _adStrategey;

static AdStrategyManager *adManager;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adManager = [[AdStrategyManager alloc] init];
    });
    return adManager;
}

///经过随机数重新排列的广告
- (HHAdStrategy *)shortedAdStrategey {
    
    [self shortSF];
    return _shortedAdStrategey;
    
}

//排序算法
- (void)shortSF {
    if (!_adStrategey || _shortedAdStrategey) {
        return;
    }
    _shortedAdStrategey = [[HHAdStrategy alloc] init];
    int total = 0;
    int count = (int)(_adStrategey.ratios.count);
    for (int i = 0; i < count;i++) {
        total += [_adStrategey.ratios[i] intValue];
    }
    NSMutableArray<AdPosition *> *ads = _adStrategey.adPositions.mutableCopy;
    NSMutableArray<NSNumber *> *ratios = _adStrategey.ratios.mutableCopy;
    
    NSMutableArray *sortArr = [NSMutableArray arrayWithArray:ratios];
    for (int i = 0; i < count; i++) {
        
        int x = arc4random() % (total + 1);
        if (i != 0) {
            [sortArr removeObjectAtIndex:0];
        }
        int index = [self indexWithArr:sortArr random:x totalRatios:total];
        
        [self changeArray:ratios oriIndex:i index:index + i];
        [self changeArray:ads oriIndex:i index:index + i];
        
        total -= [ratios[i] intValue];
        
    }
    _shortedAdStrategey.adPositions = ads.copy;
    _shortedAdStrategey.ratios = ratios.copy;
}

//交换数组中两个元素
- (void)changeArray:(NSMutableArray *)array
              oriIndex:(int)oriIndex
              index:(int)index {
    
    id temp = array[oriIndex];
    array[oriIndex] = array[index];
    array[index] = temp;
}
//根据数组 随机数以及总数求出数组中index
- (int)indexWithArr:(NSArray *)array
             random:(int)random
        totalRatios:(int)total {
    int temp = 0;
    for (int i = 0; i < array.count;i++) {
        temp += [array[i] intValue];
        if (random > temp) {
            continue;
        } else {
            
            return i;
        }
    }
    return -1;
    
}




@end

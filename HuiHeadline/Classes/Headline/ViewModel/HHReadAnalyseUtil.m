//
//  HHReadAnalyseUtil.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHReadAnalyseUtil.h"
#import <UMMobClick/MobClick.h>



@implementation AntifraudReadActionInfo


- (void)increaseDownMotionEvent:(UITouch *)touch {
    
    ++_downCount;
    
    if (([UIDevice currentDevice].systemVersion.floatValue < 9.0f)) {
        return;
    }
    @try {
        float averagePressure = (_downAvgPressure * (_downCount - 1) + touch.force ) / _downCount;
        _downAvgPressure = averagePressure;
        
        NSMutableSet *set = nil;
        if (!_toolTypes) {
            set = [NSMutableSet set];
        } else {
            set = [NSMutableSet setWithArray:_toolTypes];
        }
        [set addObject:@(touch.type)];
        _toolTypes = [set sortedArrayUsingDescriptors:@[]];
        
    } @catch (NSException *error) {
        NSLog(@"%@",error);
        
    }
    
    
}


- (void)increaseMoveMotionEvent:(UITouch *)touch {
    
    ++_moveCount;
    if (([UIDevice currentDevice].systemVersion.floatValue < 9.0f)) {
        return;
    }
    @try {
        float averageMovePressure = (_moveAvgPressure * (_moveCount - 1) + touch.force) / _moveCount;
        _moveAvgPressure = averageMovePressure;
        
    } @catch (NSException *error) {
        
        
    }
}

@end


@implementation HHReadAnalyseUtil




@end

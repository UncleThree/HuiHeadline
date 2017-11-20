//
//  HHReadAnalyseUtil.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AntifraudReadActionInfo : NSObject

@property (nonatomic, assign)BOOL monkey;

@property (nonatomic, strong)NSArray<NSNumber *> *toolTypes;

@property (nonatomic, assign)NSInteger maxHistorySize;

@property (nonatomic, assign)float downAvgPressure;

@property (nonatomic, assign)float moveAvgPressure;

@property (nonatomic, assign)NSInteger downCount;

@property (nonatomic, assign)NSInteger moveCount;

- (void)increaseDownMotionEvent:(UITouch *)touch;

- (void)increaseMoveMotionEvent:(UITouch *)touch;

@end

@interface HHReadAnalyseUtil : NSObject




@end

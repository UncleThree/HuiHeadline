//
//  HHAdStrategy.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHAdStrategy.h"

@implementation AdPosition

- (NSString *)description {
    
    return [NSString stringWithFormat:@"mode:%@, positionId:%@", _mode, _positionId];
}

@end

@implementation HHAdStrategy

//向mj_extension 说明数组中存放的是什么类型
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"adPositions" : @"AdPosition",
             @"ratios":@"NSNumber"
              };
}


- (NSString *)description {
    
    return [NSString stringWithFormat:@"adPositions:%@, ratios:%@", _adPositions, _ratios];
}


@end



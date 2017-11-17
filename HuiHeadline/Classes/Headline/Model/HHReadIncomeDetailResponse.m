//
//  HHReadIncomeDetailResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/11.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHReadIncomeDetailResponse.h"

@implementation HHReadIncomeDetailResponse

//向mj_extension 说明数组中存放的是什么类型
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"records":@"HHReadIncomDetailRecord"
             };
}



@end

@implementation HHReadIncomDetailRecord

- (CGFloat)heightForCell {
    
    CGFloat height = 0;
    CGFloat cellHeight = 20;
    int lines = 0;
    lines = (self.durationCredit > 0) + (self.shareClickCredit > 0) + (self.videoDurationCredit > 0) + (self.taskCredit > 0);
    height = cellHeight * lines + 5 * (lines - 1);
    return height;
    
}

- (int)pastDay {
    return  [HHDateUtil paseDays:_day];
}




@end

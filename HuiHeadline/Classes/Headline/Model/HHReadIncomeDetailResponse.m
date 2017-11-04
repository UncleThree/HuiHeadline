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
    
    CGFloat height = 45; 
    CGFloat cellHeight = CGFLOAT(17);
    int lines = 0;
    lines = self.durationCredit > 0 + self.shareClickCredit > 0 + self.taskCredit > 0;
    height = cellHeight * lines;
    return height;
    
}




@end

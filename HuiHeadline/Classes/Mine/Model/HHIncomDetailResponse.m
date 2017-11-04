//
//  HHIncomDetailResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHIncomDetailResponse.h"

@implementation HHIncomeDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"creditDetailId":@"id"};
}

- (NSInteger)beforeToday {
    
    if (_createTime) {
        long paseDays = [HHDateUtil beforeDays:_createTime];
        return paseDays;
    }
    return -1;
    
}

- (NSArray *)timeArray {
    
    if (_createTime) {
        
        return  [HHDateUtil incomeDetailTimerFormatter:_createTime];
    }
    return nil;
    
    
}

- (NSString *)imgName {
    
    if (_type == HHCreditDetailTypeIncome) {
        
        return @"icon_income";
    } else if (_type == HHCreditDetailTypeExpenditure) {
        return @"icon_expenditure";
    } else if (_type == HHCreditDetailTypeRefund) {
        return @"icon_return";
    } else if (_type == HHCreditDetailTypeDebit) {
        return @"icon_debit";
    }
    return nil;
    
}

@end


@implementation HHIncomDetailResponse

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"creditDetailList":@"HHIncomeDetail"};
}

@end

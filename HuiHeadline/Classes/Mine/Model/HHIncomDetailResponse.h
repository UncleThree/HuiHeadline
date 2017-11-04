//
//  HHIncomDetailResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

typedef enum : NSUInteger {
    HHCreditDetailTypeIncome = 1,      //收入
    HHCreditDetailTypeExpenditure = 2, //支出
    HHCreditDetailTypeRefund = 3,      //退款
    HHCreditDetailTypeDebit = 4        //扣罚
} HHCreditDetailType;

#import "HHResponse.h"

@interface HHIncomeDetail : NSObject

@property (nonatomic, assign)NSInteger creditDetailId;

@property (nonatomic, assign)long createTime;

@property (nonatomic, assign)NSInteger credit;

@property (nonatomic, copy)NSString *detail;

@property (nonatomic, assign)NSInteger refId;

@property (nonatomic, assign)NSInteger source;

@property (nonatomic, assign)HHCreditDetailType type;

@property (nonatomic, assign)NSInteger userId;
///距离今天多少天
@property (nonatomic, assign)NSInteger beforeToday;

@property (nonatomic, copy)NSString *imgName;

@property (nonatomic, copy)NSArray *timeArray;

@end

@interface HHIncomDetailResponse : HHResponse

@property (nonatomic, strong)NSArray<HHIncomeDetail *> *creditDetailList;

@property (nonatomic, assign)long  systemTime;


@end

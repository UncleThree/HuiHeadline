//
//  HHCreditSummaryResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUserCreditSummary : NSObject

///剩余金币
@property (nonatomic, copy)NSString *remaining;
///今日金币
@property (nonatomic, copy)NSString *todayIncome;
///总金币
@property (nonatomic, copy)NSString *total;

@end

@interface HHCreditSummaryResponse : NSObject

@property (nonatomic)int statusCode;

@property (nonatomic, copy)NSString *msg;


@property (nonatomic, strong)HHUserCreditSummary *userCreditSummary;

@end



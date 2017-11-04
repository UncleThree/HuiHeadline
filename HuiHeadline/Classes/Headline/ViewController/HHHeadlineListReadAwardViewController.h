//
//  HHHeadlineListReadAwardViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHReadAward.h"
#import "HHReadIncomeDetailResponse.h"

@interface HHHeadlineListReadAwardViewController : UIViewController


@property (nonatomic, strong)NSMutableArray<HHReadAward *> *descriptions;

@property (nonatomic, strong)HHReadIncomeDetailResponse *income;

@end

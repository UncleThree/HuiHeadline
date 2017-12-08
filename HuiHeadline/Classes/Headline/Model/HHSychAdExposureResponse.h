//
//  HHSychAdExposureResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface ListAdEncourageInfo : NSObject

@property (nonatomic, assign)NSInteger avaliableSeconds;
@property (nonatomic, assign)NSInteger credit;
@property (nonatomic, assign)long token;

@property (nonatomic, assign)long startTime;


@end

@interface HHSychAdExposureResponse : HHResponse

@property (nonatomic, strong)NSDictionary<NSString *, ListAdEncourageInfo *> *encourageInfoMap;

@end

//
//  HHInvitedConstributionSummaryResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHInvitedConstributionSummary : NSObject

@property (nonatomic, strong)NSString *phone;

@property (nonatomic, assign)NSInteger credit;

@property (nonatomic, strong)NSString *detail;

@property (nonatomic, assign)long createTime;

@property (nonatomic, assign)long lastModifiedTime;

@end

@interface HHInvitedConstributionSummaryResponse : HHResponse

@property (nonatomic, assign)long systemTime;

@property (nonatomic, strong)NSArray<HHInvitedConstributionSummary *> *userInviteeContributionSummaries;

@end

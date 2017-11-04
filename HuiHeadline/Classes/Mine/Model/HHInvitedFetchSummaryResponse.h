//
//  HHInvitedFetchSummaryResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHUserInviteInfo : NSObject
///邀请码
@property (nonatomic,copy)NSString *code;
///徒弟个数
@property (nonatomic)NSInteger count;

@property (nonatomic)NSInteger totalCredit;

@end

@interface HHInvitedFetchSummaryResponse : HHResponse

@property (nonatomic)BOOL beInvited;
///邀请奖励
@property (nonatomic)NSInteger inviteRewardCredit;
///徒弟获取 ** 金币
@property (nonatomic)NSInteger inviteeContributionCredit;
///师傅获得 ** 金币
@property (nonatomic)NSInteger rewardCreditPerContributionCredit;

@property (nonatomic, strong)HHUserInviteInfo *userInviteInfo;

@end



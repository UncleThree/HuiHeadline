//
//  HHInvitedSummaryResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHInvitedSummary : NSObject

@property (nonatomic, strong)NSString *phone;

@property (nonatomic, assign)NSInteger totalCredit;
///
@property (nonatomic, assign)long state;

@property (nonatomic, assign)long lastModifiedTime;

@end

@interface HHInvitedSummaryResponse : HHResponse

@property (nonatomic, assign)long systemTime;

@property (nonatomic, strong)NSArray<HHInvitedSummary *> *userInviteeSummarys;
@end

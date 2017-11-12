//
//  HHInvitedCreditTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHInvitedConstributionSummaryResponse.h"
#import "HHInvitedSummaryResponse.h"

@interface HHInvitedCreditTableViewCell : UITableViewCell

@property (nonatomic, strong)HHInvitedConstributionSummary *model;

@property (nonatomic, strong)HHInvitedSummary *summaryModel;

@end

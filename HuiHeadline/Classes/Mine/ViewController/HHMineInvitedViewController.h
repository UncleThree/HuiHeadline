//
//  HHMineInvitedViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHInvitedJsonModel.h"
#import "HHInvitedFetchSummaryResponse.h"
#import "HHBaseViewController.h"

@interface HHMineInvitedViewController : HHBaseViewController

@property (nonatomic, strong)HHInvitedJsonModel *model;

@property (nonatomic, strong)HHInvitedFetchSummaryResponse *response;

@end

//
//  HHMainHeaderView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCreditSummaryResponse.h"

@protocol HHMineHeaderViewDelegate <NSObject>

- (void)mineHeaderViewDidClick;

@end

@interface HHMineHeaderView : UIView

@property (nonatomic, weak)id <HHMineHeaderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame user:(HHUserModel *)user;

- (instancetype)initWithFrame:(CGRect)frame
                         user:(HHUserModel *)user
                      summary:(HHUserCreditSummary *)summary;

@end

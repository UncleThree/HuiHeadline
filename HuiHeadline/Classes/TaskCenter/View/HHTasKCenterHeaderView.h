//
//  HHTasKCenterHeaderView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHSignRecordResponse.h"

@protocol  HHTaskCenterHeaderViewDelegate <NSObject>

- (void)taskCenterHeaderViewClickSign;

- (void)taskCenterHeaderViewClickHowToMakeMoney;

@end

@interface HHTasKCenterHeaderView : UIView

@property (nonatomic, weak)id<HHTaskCenterHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     response:(HHSignRecordResponse *)response;

@end

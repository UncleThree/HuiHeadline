//
//  HHVideoDetailBottomView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHHeadlineNewsDetailProgressView.h"

@protocol HHVideoDetalBottomViewDelegate <NSObject>


- (void)clickFold;

- (void)clickProgressView;

- (void)clickAd:(HHAdModel *)ad;

- (void)exposure:(HHAdModel *)adModel;

@end



@interface HHVideoDetailBottomView : UIView

@property (nonatomic, assign)id<HHVideoDetalBottomViewDelegate> delegate;

@property (nonatomic, strong)HHHeadlineNewsDetailProgressView *progressView;

@property (nonatomic, strong)UITableView *backTableView;

@property (nonatomic)CGFloat progress;

@end

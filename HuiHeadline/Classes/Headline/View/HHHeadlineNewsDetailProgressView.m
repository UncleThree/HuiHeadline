//
//  HHHeadlineNewsDetailProgressView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNewsDetailProgressView.h"


@interface HHHeadlineNewsDetailProgressView()

@property (nonatomic, strong) UIImageView *imgV;


@end

@implementation HHHeadlineNewsDetailProgressView

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI:frame];
    }
    return self;
    
}

- (void)initUI:(CGRect)frame {

    
    self.imgV = ({
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        iv.image = [UIImage imageNamed:@"金币"];
        [self addSubview:iv];
        iv;
    });
    
    CGFloat pad = 0.21 * PROGRESS_KWIDTH;
    self.progressView = ({
        ZZCircleProgress *pr = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(pad, pad, frame.size.width - 2 * pad, frame.size.height - 2 * pad) pathBackColor:[UIColor clearColor] pathFillColor:HUIYELLOW startAngle:-90 strokeWidth:3];
        //从上一次开始 NO则从头开始
        pr.increaseFromLast = YES;
        pr.animationModel = CircleIncreaseSameTime;
        pr.showPoint = NO;
        pr.showProgressText = NO;
        pr.notAnimated = NO;
        pr.forceRefresh = YES;
        //是否在set的值等于上次值时同样刷新动画，默认为NO
        [self.imgV addSubview:pr];
        pr;
    });
}




@end

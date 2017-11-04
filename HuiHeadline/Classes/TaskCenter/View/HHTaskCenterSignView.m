//
//  HHTaskCenterSignView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskCenterSignView.h"

@interface HHTaskCenterSignView ()

@property (nonatomic, strong)UIImageView *signImageView;

@property (nonatomic, strong)UILabel *signLabel;

@property (nonatomic, strong)UILabel *coinLabel;


@end

@implementation HHTaskCenterSignView

- (instancetype)initWithFrame:(CGRect)frame
                       state:(int)state {
    
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame state:state];
    }
    return self;
    
}

- (void)initUI:(CGRect)frame
         state:(int)state {
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    self.signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.signImageView.image = [UIImage imageNamed:@"sign_bg"];
    [self addSubview:self.signImageView];
    
    CGFloat leftPad = 15;
    CGFloat scale1 = 0.28;
    self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPad, height * scale1, width - 2 * leftPad, 25)];
    if (state) {
        self.signLabel.text = @"明日签到";
        self.signLabel.textColor = BLACK_153;
    } else {
        self.signLabel.text = @"今日签到";
        self.signLabel.textColor = HUIRED;
    }
    self.signLabel.font = Font(15);
    self.signLabel.textAlignment = 1;
    [self addSubview:self.signLabel];
    
    CGFloat scale2 = 0.595;
    self.coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * scale2 , width, 25)];
    self.coinLabel.textColor = [UIColor whiteColor];
    self.coinLabel.text = @"+100金币";
    self.coinLabel.font = Font(13);
    self.coinLabel.textAlignment = 1;
    [self addSubview:self.coinLabel];
}



@end

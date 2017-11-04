//
//  HHHeadlineAwardInstructionView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineAwardInstructionView.h"


@interface HHHeadlineAwardInstructionView ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)UIButton *iKnowButton;


@end

@implementation HHHeadlineAwardInstructionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];

    }
    return self;
    
}

- (void)initUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"时段奖励";
        label.textColor = BLACK_51;
        label.font = Font(20);
        label;
    });
    
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"送金币啦，每小时打开惠头条进入首页，均可获得50金币的时段奖励，具体金额以实际获得金币奖励为准！";
        label.font = Font(17);
        
        label.textColor = BLACK_153;
        label.numberOfLines = 0;
        label;
    });
    
    self.iKnowButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:HUIRED forState:UIControlStateNormal];
        [[button titleLabel] setFont:Font(20)];
        [button addTarget:self action:@selector(iKnow) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.iKnowButton];
    
    
    [self layout];
    
}

- (void)iKnow {
    
    [HHHeadlineAwardHUD hideInstructionView];
    
}

- (void)layout {
    
    CGFloat padding = CGFLOAT(24);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.top.equalTo(self).with.offset(CGFLOAT(28));
        make.height.mas_equalTo(20);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(CGFLOAT(31));
        make.right.equalTo(self).with.offset(-padding);
        
    }];
    
    [self.iKnowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-padding);
        make.bottom.equalTo(self).with.offset(CGFLOAT(-27));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(200);
    }];
    
}


@end

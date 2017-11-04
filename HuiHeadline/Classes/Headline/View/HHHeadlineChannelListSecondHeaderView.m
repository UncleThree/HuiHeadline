//
//  HHHeadlineChannelListSecondHeaderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/15.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineChannelListSecondHeaderView.h"

@interface HHHeadlineChannelListSecondHeaderView ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *backImageV;


@end

@implementation HHHeadlineChannelListSecondHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = Font(19);
        label.textColor = BLACK_51;
        label.text = @"频道推荐";
        label;
    });
    
    self.backImageV = ({
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"图层-1"];
        imgV;
    });
    
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.backImageV];

    
    [self layout];
}

- (void)layout {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(12);
        make.top.equalTo(self);
        make.height.mas_equalTo(self);
        
    }];
    [self.backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        UIImage *image = [UIImage imageNamed:@"图层-1"];
        CGFloat height = 20;
        make.left.equalTo(self.titleLabel.mas_right).with.offset(15/2);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(image.size.width / image.size.height * height);
        
    }];
    
//    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.backImageV).with.insets(UIEdgeInsetsMake(0, 8, 0, 6));
//
//    }];
//
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backImgV.image = [UIImage imageNamed:@"图层-1"];
    self.backImgV.contentMode = UIViewContentModeScaleAspectFill;
//    self.backImgV.clipsToBounds = YES;
    
    self.clickAddLabel.text = @"点击添加";
    self.clickAddLabel.textColor = [UIColor whiteColor];

    self.clickAddLabel.adjustsFontSizeToFitWidth = YES;
    
}

@end

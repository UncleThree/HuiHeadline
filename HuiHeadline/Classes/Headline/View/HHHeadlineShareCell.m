//
//  HHHeadlineShareCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineShareCell.h"

@interface HHHeadlineShareCell()

@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, strong)UILabel *label;

@end

@implementation HHHeadlineShareCell

- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    self.imgV =({
        UIImageView *iv = [[UIImageView alloc] init];
        iv;
    });
    self.label = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = Font(13);
        label.textColor = RGB(51, 51, 51);
        label.textAlignment = 1;
        label;
    });
    [self.contentView addSubview:self.imgV];
    [self.contentView addSubview:self.label];
    [self layout];
    
}

- (void)layout {
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(CGFLOAT(40));
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).with.offset(-10);
        
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgV.mas_bottom).with.offset(12);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
}

- (void)setImgName:(NSString *)imgName {
    self.imgV.image = [UIImage imageNamed:imgName];
    
}

- (void)setText:(NSString *)text {
    
    self.label.text = text;
}


@end

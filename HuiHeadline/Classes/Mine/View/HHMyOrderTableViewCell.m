//
//  HHMyOrderTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyOrderTableViewCell.h"


@implementation HHMyOrderTableViewCellModel

@end

@interface HHMyOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *orderImgV;

@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic)  UIView *lineView;

@end

@implementation HHMyOrderTableViewCell

- (void)setOrderInfo:(HHOrderInfo *)orderInfo {
    
    _orderInfo = orderInfo;
    
    [self.orderImgV sd_setImageWithURL:URL(orderInfo.productThumbnail)];
    self.orderNameLabel.text = orderInfo.productName;
    NSString *saleString = [NSString stringWithFormat:@"%@金币",[HHUtils insertComma:orderInfo.salePrice]];
    self.saleLabel.text = saleString;
    NSString *rmb = [NSString stringWithFormat:@"￥%.2f", orderInfo.originalPrice / 100.0f];
    self.rmbLabel.text = rmb;
    self.timeLabel.text = [HHDateUtil detailTimeFormat:orderInfo.lastModifiedTime];
    self.numberLabel.text = [NSString stringWithFormat:@"X %zd",orderInfo.count];
    
    [self.saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo([HHFontManager sizeWithText:saleString font:Font(15) maxSize:CGSizeMake(CGFLOAT_MAX, 17)].width + 2);
        make.top.equalTo(self.orderImgV);
    }];
    
    [self.rmbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleLabel.mas_bottom);
        make.right.equalTo(self.saleLabel);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo([HHFontManager sizeWithText:rmb font:self.rmbLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width + 1);
    }];
    
    if (!self.lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lineView];
    }
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.rmbLabel);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.rmbLabel);
    }];
    self.lineView.backgroundColor = BLACK_51;
    
    if (orderInfo.isDetail) {
        
        self.saleLabel.textColor = HUIRED;
        self.rmbLabel.textColor = BLACK_51;
    } else {
        self.saleLabel.textColor = BLACK_153;
        self.rmbLabel.textColor = BLACK_153;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderNameLabel.font = Font(15);
    self.orderNameLabel.textColor = BLACK_51;
    
    self.saleLabel.font = Font(15);
    self.saleLabel.textColor = BLACK_153;
    
    self.rmbLabel.font = Font(13);
    self.rmbLabel.textColor = BLACK_153;
    
    self.numberLabel.font = Font(13);
    self.numberLabel.textColor = BLACK_153;
    
    self.timeLabel.font = Font(14);
    self.timeLabel.textColor = BLACK_153;
    
    self.orderImgV.layer.cornerRadius = 5;
    self.orderImgV.layer.masksToBounds = YES;
    
//    self.saleLabel.textAlignment = 2;
//    self.rmbLabel.textAlignment = 2;
    self.numberLabel.textAlignment = 2;
    [self layout];
}

- (void)layout {
    
    CGFloat pad = 12;
    CGFloat topPad = 20;
    [self.orderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(pad);
        make.top.equalTo(self.contentView).with.offset(topPad);
        make.bottom.equalTo(self.contentView).with.offset(-topPad);
        make.width.mas_equalTo(self.contentView.mas_height).with.offset(- topPad * 2);
    }];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = BLACK_51;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rmbLabel);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.rmbLabel);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rmbLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.saleLabel);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(self.saleLabel);
    }];
    
    [self.orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderImgV.mas_right).with.offset(10);
        make.top.equalTo(self.orderImgV);
        make.right.equalTo(self.saleLabel.mas_left).with.offset(-10);
        make.bottom.lessThanOrEqualTo(self.orderImgV).with.offset(-17-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderImgV);
        make.left.equalTo(self.orderNameLabel);
        make.height.mas_equalTo(17);
        make.right.equalTo(self.contentView).with.offset(-pad);
    }];
}


@end

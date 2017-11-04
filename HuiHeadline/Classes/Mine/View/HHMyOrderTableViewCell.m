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
    self.saleLabel.text = [NSString stringWithFormat:@"%@金币",[HHUtils insertComma:orderInfo.salePrice]];
    self.rmbLabel.text = [NSString stringWithFormat:@"￥%.2f", orderInfo.originalPrice / 100.0f];
    self.timeLabel.text = [HHDateUtil detailTimeFormat:orderInfo.lastModifiedTime];
    self.numberLabel.text = [NSString stringWithFormat:@"X %zd",orderInfo.count];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(X(self.rmbLabel), Y(self.rmbLabel) + H(self.rmbLabel) / 2, W(self.rmbLabel), 0.5)];
    self.lineView.backgroundColor = BLACK_51;
    
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
}


@end

//
//  HHIncomeDetailTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHIncomeDetailTableViewCell.h"

@interface HHIncomeDetailTableViewCell ()

@property (nonatomic, strong)UIImageView *imgV;

@property (nonatomic, strong)UILabel *tLabel;

@property (nonatomic, strong)UILabel *dLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation HHIncomeDetailTableViewCell

#define cell_height 80

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    
    CGFloat imgWidth = 45;
    
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cell_height - imgWidth) / 2, imgWidth, imgWidth)];
    self.imgV.layer.cornerRadius = imgWidth / 2;
    [self.contentView addSubview:self.imgV];
    
    
    self.tLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgV) + 16, 12, 150, 20)];
    self.tLabel.textColor = BLACK_51;
    self.tLabel.font = Font(17);
    [self.contentView addSubview:self.tLabel];
    
    self.dLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.tLabel), MaxY(self.tLabel) + 10, KWIDTH - 20 - X(self.tLabel), 20)];
    self.dLabel.textColor = BLACK_51;
    self.dLabel.font = Font(15);
    [self.contentView addSubview:self.dLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.tLabel), Y(self.tLabel), KWIDTH - MaxX(self.tLabel) - 20, 20)];
    self.timeLabel.textColor = BLACK_153;
    self.timeLabel.font = Font(15);
    self.timeLabel.textAlignment = 2;
    [self.contentView addSubview:self.timeLabel];
    
    
    
}

- (void)setModel:(HHIncomeDetail *)model {
    _model = model;
    
    self.imgV.image = [UIImage imageNamed:model.imgName];
    NSString *andOrSub = (model.type == HHCreditDetailTypeIncome || model.type == HHCreditDetailTypeRefund) ? @"+" : @"-";
    NSString *creditStr = [NSString stringWithFormat:@"%@金币", [HHUtils insertComma:[NSString stringWithFormat:@"%zd",model.credit]]];
    self.tLabel.text = [andOrSub stringByAppendingString:creditStr];
    
    self.dLabel.text = [model.detail stringByAppendingString:creditStr];
    
    self.timeLabel.text = model.timeArray.count >= 2 ? model.timeArray[1] : @"";
    
}


@end

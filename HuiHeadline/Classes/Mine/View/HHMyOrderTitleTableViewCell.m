//
//  HHMyOrderTitleTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyOrderTitleTableViewCell.h"

@interface HHMyOrderTitleTableViewCell ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *stateNameLabel;

@end

@implementation HHMyOrderTitleTableViewCell

#define cell_height 45

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self statements];
    }
    return self;
}

- (void)statements {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, cell_height)];
    self.titleLabel.textColor = BLACK_153;
    self.titleLabel.font =  Font(15);
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat width = 150;
    self.stateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWIDTH - 12 -width, 0, width, cell_height)];
    self.stateNameLabel.font = Font(15);
    self.stateNameLabel.textColor = RGB(230, 53, 40);
    self.stateNameLabel.textAlignment = 2;
    [self.contentView addSubview:self.stateNameLabel];
    
}

- (void)setStateName:(NSString *)stateName {
    
    self.titleLabel.text = @"商城兑换";
    self.stateNameLabel.text = stateName;
}

@end

//
//  HHHeadlineReadAwardFirstTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineReadAwardFirstTableViewCell.h"

@interface HHHeadlineReadAwardFirstTableViewCell ()

@property (nonatomic, strong)UIView *redPoint;

@property (nonatomic, strong)UILabel *label;

@end

@implementation HHHeadlineReadAwardFirstTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.redPoint = [[UIView alloc] initWithFrame:CGRectMake(12, 11, 5, 5)];
    self.redPoint.backgroundColor = HUIRED;
    self.redPoint.layer.cornerRadius = 2.5;
    [self.contentView addSubview:self.redPoint];
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.font = Font(15);
    self.label.textColor = RGB(124, 112, 8);
    self.label.numberOfLines = 0;
    [self.contentView addSubview:self.label];
    
}

- (void)setReadAward:(HHReadAward *)readAward {
    
//    self.redPoint.center = CGPointMake(self.redPoint.center.x, self.contentView.center.y);
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPoint.mas_right).with.offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    self.label.text = readAward.text;
    self.redPoint.hidden = !readAward.hasRedPoint;
    
    
}






@end




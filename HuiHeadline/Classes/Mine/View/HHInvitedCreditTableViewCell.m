//
//  HHInvitedCreditTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHInvitedCreditTableViewCell.h"

@interface HHInvitedCreditTableViewCell ()

@property (nonatomic, strong)UILabel *tLabel;

@property (nonatomic, strong)UILabel *dLabel;

@property (nonatomic, strong)UILabel *timeLabel;


@end

@implementation HHInvitedCreditTableViewCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)setSummaryModel:(HHInvitedSummary *)summaryModel {
    
    _summaryModel  = summaryModel;
    
    NSString *title = [@"好友" stringByAppendingString:[HHUtils  phone_sec:summaryModel.phone]];
    self.tLabel.text = title;
    
    self.dLabel.text = [HHDateUtil invitedTime:summaryModel.lastModifiedTime];
    self.dLabel.textColor = BLACK_153;
    
    NSString *credit = [NSString stringWithFormat:@"%zd金币",summaryModel.totalCredit];
    NSMutableAttributedString *creditatt = [[NSMutableAttributedString alloc] initWithString:credit attributes:@{KEY_FONT:Font(16),KEY_COLOR:HUIRED}];
    [creditatt addAttribute:KEY_COLOR value:BLACK_51 range:[credit rangeOfString:@"金币"]];
    self.timeLabel.attributedText = creditatt;
}

- (void)setModel:(HHInvitedConstributionSummary *)model {
    
    _model = model;
    
    NSString *title = [@"好友" stringByAppendingString:[HHUtils  phone_sec:model.phone]];
    self.tLabel.text = title;
    NSString *credit = [NSString stringWithFormat:@"%@：%zd金币",model.detail, model.credit];
    NSMutableAttributedString *creditatt = [[NSMutableAttributedString alloc] initWithString:credit attributes:@{KEY_FONT:Font(16),KEY_COLOR:HUIRED}];
    [creditatt addAttribute:KEY_COLOR value:BLACK_153 range:[credit rangeOfString:[NSString stringWithFormat:@"%@：",model.detail]]];
    self.dLabel.attributedText = creditatt;
    
    self.timeLabel.text = [HHDateUtil creditTimeFormat:model.lastModifiedTime];
    
}


- (void)initUI {
    
    self.tLabel = [UILabel new];
    self.tLabel.textColor = BLACK_51;
    self.tLabel.font = kTitleFont;
    [self.contentView addSubview:self.tLabel];
    
    self.dLabel = [UILabel new];
    self.dLabel.font = Font(16);
    [self.contentView addSubview:self.dLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = BLACK_153;
    self.timeLabel.font = Font(16);
    self.timeLabel.textAlignment = 2;
    [self.contentView addSubview:self.timeLabel];
    
    CGFloat topPad = 10;
    CGFloat leftPad = 12;
    
    [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(topPad);
        make.left.equalTo(self.contentView).with.offset(leftPad);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.dLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView).with.offset(-topPad);
        make.left.equalTo(self.contentView).with.offset(leftPad);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tLabel);
        make.right.equalTo(self.contentView).with.offset(-leftPad);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(15);
    }];
    
}


@end

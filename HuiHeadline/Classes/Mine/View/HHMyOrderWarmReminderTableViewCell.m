//
//  HHMyOrderWarmReminderTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyOrderWarmReminderTableViewCell.h"

@interface HHMyOrderWarmReminderTableViewCell ()

@property (nonatomic, strong)UILabel *tLabel;

@property (nonatomic, strong)UILabel *dLabel;

@end

@implementation HHMyOrderWarmReminderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UIFont *font = Font(15);
    CGFloat height = 20;
    NSString *text = @"温馨提示：";
    self.tLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [HHFontManager sizeWithText:text font:font maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width, height)];
    self.tLabel.textColor = BLACK_51;
    self.tLabel.text = text;
    self.tLabel.font = font;
    [self.contentView addSubview:self.tLabel];
    
    CGFloat leftPad = 5;
    self.dLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.tLabel) + leftPad, 10, KWIDTH - 40 - W(self.tLabel) - leftPad, 20)];
    self.dLabel.numberOfLines = 0;
    self.dLabel.textColor = BLACK_51;
    self.dLabel.font = Font(15);
    [self.contentView addSubview:self.dLabel];
    
}

- (void)setFeedback:(NSString *)feedback {
    
    self.dLabel.frame = CGRectMake(X(self.dLabel), Y(self.dLabel), W(self.dLabel), [HHFontManager sizeWithText:feedback font:Font(15) maxSize:CGSizeMake(W(self.dLabel), CGFLOAT_MAX)].height);
    self.dLabel.text = feedback;
}

@end

//
//  HHMineItemTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineItemTableViewCell.h"

@interface HHMineItemTableViewCell ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *subLabel;

@property (nonatomic, strong)UIImageView *nextImageView;

@end

@implementation HHMineItemTableViewCell

#define HEIGHT 50

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, KWIDTH / 2, HEIGHT)];
    self.titleLabel.textColor = BLACK_51;
    self.titleLabel.font = Font(16);
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat width = 10;
    UIImage *image = [UIImage imageNamed:@"item_view_right_arrow"];
    CGFloat height = image.size.height / image.size.width * width;
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 12 - width, (HEIGHT - height) / 2, width, height)];
    self.nextImageView.image = image;
    [self.contentView addSubview:self.nextImageView];
    
    CGFloat pad = 20;
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.nextImageView) - pad - KWIDTH / 3, 0, KWIDTH / 3 , HEIGHT)];
    self.subLabel.font = Font(16);
    self.subLabel.textColor = BLACK_51;
    self.subLabel.textAlignment = 2;
    [self.contentView addSubview:self.subLabel];
    
}

- (void)setModel:(HHMineItemCellModel *)model {
    
    self.titleLabel.text = model.title;
    if ([model.subTitle containsString:@"金币"]) {
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.subTitle attributes:@{KEY_COLOR:BLACK_51}];
        [attStr addAttribute:KEY_COLOR value:HUIRED range:(NSMakeRange(0, model.subTitle.length - 2))];
        self.subLabel.attributedText = attStr.copy;
        
    } else {
        self.subLabel.text = model.subTitle;
    }
    
}

@end

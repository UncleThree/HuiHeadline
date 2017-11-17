//
//  HHMallBindTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallBindTableViewCell.h"

@interface HHMallBindTableViewCell ()

@property (nonatomic, strong)UIImageView *leftImgV;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *nextImgV;

@end

@implementation HHMallBindTableViewCell

#define HEIGHT 60

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    CGFloat imgWidth = 25;
    self.leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, (HEIGHT - imgWidth) / 2, imgWidth, imgWidth)];
    [self.contentView addSubview:self.leftImgV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgV) + 15, 0, KWIDTH * 0.7, HEIGHT)];
    self.titleLabel.font = Font(17);
    self.titleLabel.textColor = BLACK_51;
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat nextWidth = 10;
    UIImage *image = [UIImage imageNamed:@"icon_go_help"];
    CGFloat nextHeight = image.size.height / image.size.width * nextWidth;
    self.nextImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 20 - nextWidth, (HEIGHT - nextHeight) / 2, nextWidth, nextHeight)];
    [self.contentView addSubview:self.nextImgV];
    
    
}

- (void)setModel:(HHMineNormalCellModel *)model {
    
    if (!model) {
        return;
    }
    _model = model;
    self.leftImgV.image = [UIImage imageNamed:model.imgName];
    self.titleLabel.text = model.text;
    
    UIImage *image = [UIImage imageNamed:@"icon_go_help"];
    self.nextImgV.image = image;
}


@end

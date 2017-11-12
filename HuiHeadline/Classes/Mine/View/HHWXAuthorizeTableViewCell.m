//
//  HHWXAuthorizeTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHWXAuthorizeTableViewCell.h"


@implementation HHWXAuthorizeModel



@end


@interface HHWXAuthorizeTableViewCell ()

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)UIImageView *nextImgV;

@property (nonatomic, strong)UILabel *subLabel;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UIImageView *headerImgV;


@end


@implementation HHWXAuthorizeTableViewCell

#define cell_height 60


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    UIFont *font = Font(16);
    CGFloat labelWidth = [HHFontManager sizeWithText:@"啦啦啦啦：" font:font maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, labelWidth + 20, cell_height)];
    self.label.font = font;
    self.label.textColor = BLACK_153;
    [self.contentView addSubview:self.label];
    
    CGFloat nextImageWidth = 5;
    UIImage *image = [UIImage imageNamed:@"next"];
    self.nextImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 20 - nextImageWidth, 0, nextImageWidth, nextImageWidth / image.size.width * image.size.height)];
    self.nextImgV.image = image;
    self.nextImgV.center = CGPointMake(self.nextImgV.center.x, cell_height / 2);
    [self.contentView addSubview:self.nextImgV];
    
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.label), 0, KWIDTH - MaxX(self.label) - 20 - 12 - nextImageWidth, cell_height)];
    self.subLabel.text = @"去授权";
    self.subLabel.textColor = BLACK_153;
    self.subLabel.font = font;
    self.subLabel.textAlignment = 2;
    [self.contentView addSubview:self.subLabel];
    
    
    CGFloat imgWidth = 45;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.label) , 0, KWIDTH - 40 - W(self.label) - imgWidth, cell_height)];
    self.nameLabel.textColor = BLACK_153;
    self.nameLabel.font = font;
    [self.contentView addSubview:self.nameLabel];
    
    self.headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(X(self.nextImgV) - 12 - imgWidth, (cell_height - imgWidth) / 2, imgWidth, imgWidth)];
    self.headerImgV.layer.cornerRadius = imgWidth / 2.0f;
    self.headerImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImgV];
    
    
    
}

- (void)setModel:(HHWXAuthorizeModel *)model {
    
    _model = model;
    self.label.text = model.labelText;
    if (!model.authorized) {
        self.subLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.headerImgV.hidden = YES;
    } else {
        
        self.nameLabel.hidden = NO;
        self.headerImgV.hidden = NO;
        self.subLabel.hidden = YES;
        
        self.nameLabel.text = model.wxName;
        [self.headerImgV sd_setImageWithURL:URL(model.headerUrl)];
    }
    if (model.enabled) {
        self.nameLabel.textColor = BLACK_51;
    } else {
        self.nameLabel.textColor = BLACK_153;
    }
    
}


@end

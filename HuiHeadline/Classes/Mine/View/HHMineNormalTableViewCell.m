//
//  HHMineNormalTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineNormalTableViewCell.h"

@interface  HHMineNormalTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImgV;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) HHMainNormalRedBackAndLabelView *redView;

@property (nonatomic, strong) UIImageView *nextImgV;

@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, strong) UIImageView *subImageView;

@end

@implementation HHMineNormalTableViewCell

#define CELL_HEIGHT  50.0



- (void)setModel:(HHMineNormalCellModel *)model {
    
    self.leftImgV.image = [UIImage imageNamed:model.imgName];
    self.label.text = model.text;
    if (model.hasNew) {
        
        [self initRedView:model.redText];
    }
    if (model.hasSub) {
        [self initSubImgAndLabel:model.subText];
    }
    
    
}

- (void)initRedView:(NSString *)text {
    
    self.redView = [[HHMainNormalRedBackAndLabelView alloc] initWithFrame:CGRectMake(MaxX(self.label) + 5, 0, 100, 30) text:text];
    self.redView.center =CGPointMake(self.redView.center.x, self.contentView.center.y);
    [self.contentView addSubview:self.redView];
}

- (void)initSubImgAndLabel:(NSString *)text {
    
    CGFloat redPacketImageWidth = 25.0f;
    UIImage *redPacketImage = [UIImage imageNamed:@"main_redPacket"];
    self.subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X(self.nextImgV) - 7 - redPacketImageWidth , 0, redPacketImageWidth, redPacketImage.size.height /redPacketImage.size.width * redPacketImageWidth)];
    self.subImageView.image = redPacketImage;
    self.subImageView.center = CGPointMake(self.subImageView.center.x, self.contentView.center.y);
    [self.contentView addSubview:self.subImageView];
    
    CGFloat subLabelHeight = 20.0f;
    UIFont *font = Font(14);
    CGFloat subLabelWidth = [HHFontManager sizeWithText:text font:font maxSize:CGSizeMake(CGFLOAT_MAX, subLabelHeight)].width;
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.subImageView) - 5 - subLabelWidth, 0, subLabelWidth, subLabelHeight)];
    self.subLabel.text = text;
    self.subLabel.font = font;
    self.subLabel.textColor = BLACK_153;
    self.subLabel.center = CGPointMake(self.subLabel.center.x, self.contentView.center.y);
    [self.contentView addSubview:self.subLabel];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        
    }
    return self;
    
}

- (void)initUI {
    CGFloat leftPad = 12;
    CGFloat topPad = 12;
    CGFloat imgWidth = 20;
    self.leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(leftPad, 0, imgWidth, imgWidth)];
    self.leftImgV.center = CGPointMake(self.leftImgV.center.x, CELL_HEIGHT / 2);
    [self.contentView addSubview:self.leftImgV];
    
    CGFloat height = 20;
    UIFont *font = Font(15);
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(MaxY(self.leftImgV) + 15, 0, [HHFontManager sizeWithText:@"惠头条惠头条" font:font maxSize:CGSizeMake(CGFLOAT_MAX, height)].width, height)];
    self.label.center = CGPointMake(self.label.center.x, CELL_HEIGHT / 2);
    self.label.font = font;
    self.label.textColor = BLACK_51;
    [self.contentView addSubview:self.label];
    
    CGFloat nextImageWidth = 5;
    UIImage *image = [UIImage imageNamed:@"next"];
    self.nextImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 12 - nextImageWidth, topPad, nextImageWidth, nextImageWidth / image.size.width * image.size.height)];
    self.nextImgV.image = image;
    self.nextImgV.center = CGPointMake(self.nextImgV.center.x, CELL_HEIGHT / 2);
    [self.contentView addSubview:self.nextImgV];
}



@end



@interface HHMainNormalRedBackAndLabelView ()

@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UILabel *label;


@end

@implementation HHMainNormalRedBackAndLabelView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text {
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat height = 18.0f;
        UIImage *image = [UIImage imageNamed:@"red_back"];
        CGFloat width = image.size.width / image.size.height * height;
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.backImageView.image = image;
        self.backImageView.center = CGPointMake(self.backImageView.center.x, self.center.y);
        [self addSubview:self.backImageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.text = text;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:12];
        [self.backImageView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backImageView).with.offset(width * 0.2f);
            make.right.equalTo(self.backImageView).with.offset(-width * 0.0f);
            make.top.and.bottom.equalTo(self.backImageView);
        }];
        
    }
    return self;
    
    
}




@end



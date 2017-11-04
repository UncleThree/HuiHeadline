//
//  HHHeadlineNewsLeftRightTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNewsLeftRightTableViewCell.h"


@interface HHHeadlineNewsLeftRightTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;


@property (nonatomic, strong) UIImageView *walletImgV;
@property (strong, nonatomic) UILabel *awardLabel;

@property (nonatomic, strong)UILabel *setTopLabel;


@end


@implementation HHHeadlineNewsLeftRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = BLACK_51;
    self.titleLabel.font = kTitleFont;
    
    self.subLabel.textColor = BLACK_153;
    self.subLabel.font = kSubtitleFont;
    
    
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftImgV.mas_right).with.offset(12);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.bottom.equalTo(self.leftImgV);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.subLabel.mas_top);
    }];
    
    self.subLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setNewsModel:(HHNewsModel *)newsModel {
    
    
    //点击颜色变化
    self.titleLabel.textColor = newsModel.hasClicked ? BLACK_153 : BLACK_51;
    
    NSURL *url = nil;
    if (newsModel.lbimg.count) {
        url = URL(newsModel.lbimg[0][@"src"]);
    }
    [self.leftImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    self.titleLabel.text = newsModel.title;
    self.subLabel.text = newsModel.subTitle;
    
    [self hideSetTopLabel];
}

- (void)setAdModel:(HHAdModel *)adModel {
    
    
    //点击颜色变化
    self.titleLabel.textColor = adModel.hasClicked ? BLACK_153 : BLACK_51;
    
    self.titleLabel.text = adModel.subTitle ?: adModel.title;
    self.subLabel.text = @"广告";
    NSURL *url = URL(adModel.imgList[0]);
    [self.leftImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    if (adModel.AdAwards) {
        [self addAward];
    }
    
    [self hideSetTopLabel];
}

- (void)setTopModel:(HHTopNewsModel *)topModel {
    
    self.titleLabel.textColor = topModel.hasClicked ? BLACK_153 : BLACK_51;
    self.titleLabel.text = topModel.title;
    self.subLabel.text = topModel.subTitle;
    [self.leftImgV sd_setImageWithURL:URL(topModel.pictures) placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    [self addSetTopLabel:topModel];
}


- (void)addSetTopLabel:(HHTopNewsModel *)topModel {
    
    UIFont *font = kSubtitleFont;
    CGFloat height = 18;
    NSString *zd = @"置顶";
    CGFloat width = [HHFontManager sizeWithText:zd font:font maxSize:CGSizeMake(CGFLOAT_MAX, 25)].width;
    if (!self.setTopLabel) {
        self.setTopLabel = [[UILabel alloc] init];
        self.setTopLabel.textColor = HUIRED;
        self.setTopLabel.font = font;
        self.setTopLabel.textAlignment = 1;
        self.setTopLabel.layer.cornerRadius = 2;
        self.setTopLabel.layer.borderWidth = 0.5;
        self.setTopLabel.layer.borderColor = HUIRED.CGColor;
        self.setTopLabel.text = zd;
        [self.contentView addSubview:self.setTopLabel];
        [self.setTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImgV.mas_right).with.offset(12);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width + 2);
            make.bottom.equalTo(self.leftImgV);
        }];
    }
    self.setTopLabel.hidden = NO;
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.setTopLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.setTopLabel);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.height.mas_equalTo(height);
    }];
    
    
}

- (void)hideSetTopLabel {
    self.setTopLabel.hidden = YES;
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftImgV.mas_right).with.offset(12);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.bottom.equalTo(self.leftImgV);
    }];
}

///添加奖励图标
- (void)addAward {
    
    self.walletImgV = ({
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"红包"];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        imgV;
    });
    
    self.awardLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.adModel.AdAwards;
        label.textColor = HUIRED;
        label.font = Font(14);
        label;
    });
    
    [self.contentView addSubview:self.awardLabel];
    [self.contentView addSubview:self.walletImgV];
    
    [self layout];
}

- (void)layout {
    
    [self.walletImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subLabel.mas_right).with.offset(CGFLOAT(12));
        make.bottom.equalTo(self.subLabel.mas_bottom).with.offset(2);
        make.height.equalTo(self.subLabel).with.offset(7);
        UIImage *image = self.walletImgV.image;
        make.width.mas_equalTo(image.size.width / image.size.height * H(self.subLabel) + 7);
    }];
    
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletImgV.mas_right).with.offset(2.5);
        make.centerY.equalTo(self.subLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
}





@end

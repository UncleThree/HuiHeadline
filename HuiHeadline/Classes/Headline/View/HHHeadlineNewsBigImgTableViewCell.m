//
//  HHHeadlineNewsBigImgTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNewsBigImgTableViewCell.h"


@interface HHHeadlineNewsBigImgTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;


@property (nonatomic, strong) UIImageView *walletImgV;
@property (strong, nonatomic) UILabel *awardLabel;

@property (nonatomic, strong)UILabel *setTopLabel;

@end

@implementation HHHeadlineNewsBigImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = BLACK_51;
    self.titleLabel.font = kTitleFont;
    
    self.subLabel.textColor = BLACK_153;
    self.subLabel.font = kSubtitleFont;
    
    
    
}


- (void)setNewsModel:(HHNewsModel *)newsModel {
    
    
    self.titleLabel.textColor = newsModel.hasClicked ? BLACK_153 : BLACK_51;
    
    NSURL *url = URL(newsModel.url);
    [self.imgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    self.titleLabel.text = newsModel.title;
    self.subLabel.text = newsModel.subTitle;
    
    [self hideSetTopLabel];
    [self hideAward];
}

- (void)setAdModel:(HHAdModel *)adModel {
    
    
    //点击颜色变化
    self.titleLabel.textColor = adModel.hasClicked ? BLACK_153 : BLACK_51;
    
    self.titleLabel.text = adModel.subTitle ?: adModel.title;
    self.subLabel.text = @"广告";
    NSURL *url = URL(adModel.imgList[0]);
    [self.imgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    if (adModel.AdAwards) {
        [self addAward:adModel];
    } else {
        
        [self hideAward];
    }
    
    [self hideSetTopLabel];
    
}

- (void)setTopModel:(HHTopNewsModel *)topModel {
    
    self.titleLabel.textColor = topModel.hasClicked ? BLACK_153 : BLACK_51;
    self.titleLabel.text = topModel.title;
    self.subLabel.text = topModel.subTitle;
    [self.imgV sd_setImageWithURL:URL(topModel.pictures) placeholderImage:[UIImage imageNamed:@"place_image"]];
    
    [self addSetTopLabel];
    [self hideAward];
}


- (void)addSetTopLabel {
    
    if (!self.setTopLabel) {
       
        UIFont *font = K_Font(12);
        NSString *zd = @"置顶";
        CGFloat width = [HHFontManager sizeWithText:zd font:font maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
        CGFloat height = [HHFontManager sizeWithText:zd font:font maxSize:CGSizeMake(width, CGFLOAT_MAX)].height;
        
        self.setTopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.setTopLabel.textColor = HUIRED;
        self.setTopLabel.font = font;
        self.setTopLabel.textAlignment = 1;
        self.setTopLabel.layer.cornerRadius = 2;
        self.setTopLabel.layer.borderWidth = 0.5;
        self.setTopLabel.layer.borderColor = HUIRED.CGColor;
        self.setTopLabel.text = zd;
        [self.contentView addSubview:self.setTopLabel];
        [self.setTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width + 2);
            make.top.equalTo(self.imgV.mas_bottom).with.offset(12);
        }];
    }
    self.setTopLabel.hidden = NO;
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.setTopLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.setTopLabel);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
    
    
    
}

- (void)hideSetTopLabel {
    self.setTopLabel.hidden = YES;
    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgV.mas_bottom).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(12);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
}

- (void)hideAward {
    
    [self.walletImgV setHidden:YES];
    self.awardLabel.hidden = YES;
}


///添加奖励图标
- (void)addAward:(HHAdModel *)adModel {
    
    if (!self.walletImgV) {
        UIImage *image = [UIImage imageNamed:@"红包"];
        self.walletImgV =  [[UIImageView alloc] initWithFrame:CGRectZero];
        self.walletImgV.image = image;
        self.walletImgV.contentMode = UIViewContentModeScaleAspectFill;
        self.walletImgV.clipsToBounds = YES;
        
        
        self.awardLabel =  [[UILabel alloc] initWithFrame:CGRectZero];
        self.awardLabel.textColor = HUIRED;
        self.awardLabel.font = Font(14);
        
        [self.contentView addSubview:self.awardLabel];
        [self.contentView addSubview:self.walletImgV];
    }
    
    self.awardLabel.text = adModel.AdAwards;
    self.awardLabel.hidden = NO;
    self.walletImgV.hidden = NO;
    [self layout];
}

- (void)layout {
    
    [self.walletImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.subLabel.mas_left).with.offset(35);
        make.bottom.equalTo(self.subLabel.mas_bottom).with.offset(2);
        make.height.equalTo(self.subLabel).with.offset(7);
        UIImage *image = self.walletImgV.image;
        make.width.mas_equalTo(image.size.width / image.size.height * 20 + 7);
    }];
    
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletImgV.mas_right).with.offset(2.5);
        make.centerY.equalTo(self.subLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
}





@end

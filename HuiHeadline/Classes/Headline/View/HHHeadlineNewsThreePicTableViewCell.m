//
//  HHHeadlineNewsThreePicTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNewsThreePicTableViewCell.h"

@interface HHHeadlineNewsThreePicTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgV;

@property (weak, nonatomic) IBOutlet UIImageView *secImgV;

@property (weak, nonatomic) IBOutlet UIImageView *thrImgV;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *walletImgV;
@property (strong, nonatomic) UILabel *awardLabel;

@property (nonatomic, strong)UILabel *setTopLabel;





@end


@implementation HHHeadlineNewsThreePicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = kTitleFont;
    self.titleLabel.textColor = BLACK_51;
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstImgV.mas_bottom).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(12);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
    self.subTitleLabel.font = kSubtitleFont;
    self.subTitleLabel.textColor = BLACK_153;
    
}



- (void)setNewsModel:(HHNewsModel *)newsModel {
    
    
    //点击颜色变化
    self.titleLabel.textColor = newsModel.hasClicked ? BLACK_153 : BLACK_51;

    self.titleLabel.text = newsModel.title;
    self.subTitleLabel.text = newsModel.subTitle;
    [self setImage:self.firstImgV urlString:newsModel.miniimg[0][@"src"] placeholder:@"place_image"];
    [self setImage:self.secImgV urlString:newsModel.miniimg[1][@"src"] placeholder:@"place_image"];
    [self setImage:self.thrImgV urlString:newsModel.miniimg[2][@"src"] placeholder:@"place_image"];
    
    [self hideSetTopLabel];
    
}

- (void)setAdModel:(HHAdModel *)adModel {
    
    
    
    //点击颜色变化
    self.titleLabel.textColor = adModel.hasClicked ? BLACK_153 : BLACK_51;
    
    self.titleLabel.text = adModel.subTitle ?: adModel.title;
    self.subTitleLabel.text = @"广告";
    [self setImage:self.firstImgV urlString:adModel.imgList[0] placeholder:@"place_image"];
    
    if (adModel.imgList.count > 2) {
        [self setImage:self.secImgV urlString:adModel.imgList[1] placeholder:@"place_image"];
        [self setImage:self.thrImgV urlString:adModel.imgList[2] placeholder:@"place_image"];
    } else {
        NSLog(@"不够三张图");
        self.secImgV.image = [UIImage imageNamed:@"place_image"];
        self.thrImgV.image = [UIImage imageNamed:@"place_image"];
    }
    
    [self hideSetTopLabel];
    
    if (adModel.AdAwards) {
        [self addAward];
    }
    
    
}

- (void)setTopModel:(HHTopNewsModel *)topModel {
    
    
    
    self.titleLabel.textColor = topModel.hasClicked ? BLACK_153 : BLACK_51;
    
    self.titleLabel.text = topModel.title;
    self.subTitleLabel.text = topModel.subTitle;
    [self setImage:self.firstImgV urlString:topModel.pictureUrls[0] placeholder:@"place_image"];
    if (topModel.pictureUrls.count > 2) {
        [self setImage:self.secImgV urlString:topModel.pictureUrls[1] placeholder:@"place_image"];
        [self setImage:self.thrImgV urlString:topModel.pictureUrls[2] placeholder:@"place_image"];
    } else {
        NSLog(@"不够三张图");
        self.secImgV.image = [UIImage imageNamed:@"place_image"];
        self.thrImgV.image = [UIImage imageNamed:@"place_image"];
    }
    
    [self addSetTopLabel];
    
    
}

- (void)addSetTopLabel {
    
    if (!self.setTopLabel) {
        UIFont *font = Font(12);
        CGFloat height = 14;
        NSString *zd = @"置顶";
        CGFloat width = [HHFontManager sizeWithText:zd font:font maxSize:CGSizeMake(CGFLOAT_MAX, 25)].width;
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
            make.top.equalTo(self.firstImgV.mas_bottom).with.offset(12);
        }];
    }
    self.setTopLabel.hidden = NO;
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.setTopLabel.mas_right).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.setTopLabel);
    }];

    
    
}

- (void)hideSetTopLabel {
    self.setTopLabel.hidden = YES;
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstImgV.mas_bottom).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(12);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
}

- (void)setImage:(UIImageView *)imgView
       urlString:(NSString *)urlStr
      placeholder:(NSString *)place{
    
    [imgView sd_setImageWithURL:URL(urlStr) placeholderImage:[UIImage imageNamed:place]];
    
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
        make.left.equalTo(self.subTitleLabel.mas_right).with.offset(CGFLOAT(12));
        make.bottom.equalTo(self.subTitleLabel.mas_bottom).with.offset(2);
        make.height.equalTo(self.subTitleLabel).with.offset(7);
        UIImage *image = self.walletImgV.image;
        make.width.mas_equalTo(image.size.width / image.size.height * H(self.subTitleLabel) + 7);
    }];
    
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletImgV.mas_right).with.offset(2.5);
        make.centerY.equalTo(self.subTitleLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
}


@end

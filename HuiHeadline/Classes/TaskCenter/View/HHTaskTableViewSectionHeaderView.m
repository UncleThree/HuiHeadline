//
//  HHNewbieTaskTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskTableViewSectionHeaderView.h"

@interface HHTaskTableViewSectionHeaderView ()

@property (nonatomic, strong)UIView *lineTop;
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UIView *lineBottom;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *subLabel;

@property (nonatomic, strong)UIImageView *coinImgV;

@property (nonatomic, strong)UIImageView *nextImgV;


@end


@implementation HHTaskTableViewSectionHeaderView



- (instancetype)initWithFrame:(CGRect)frame
                        model:(HHTaskSectionHeaderModel *)model
{
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame model:model] ;
    }
    return self;
}

- (void)initUI:(CGRect)frame
         model:(HHTaskSectionHeaderModel *)model{
    
    CGFloat HEIGHT = frame.size.height;
    
    [self initTitleLabelAndNextImgV:HEIGHT model:model];
    
    if (model.completed) {
        
        [self initcomPleteImgV:HEIGHT];
        
    } else {
        [self initSubLabelAndImgV:HEIGHT model:model];
    }
    
    
}

- (void)initSubLabelAndImgV:(CGFloat)HEIGHT model:(HHTaskSectionHeaderModel *)model {
    CGFloat coinWidth = 20;
    UIImage *coinImage = model.isRedPaper ? [UIImage imageNamed:@"red_packet"] : [UIImage imageNamed:@"coin"];
    CGFloat coinHeight = coinImage.size.height / coinImage.size.width * coinWidth;
    self.coinImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 30 - 12 - coinWidth, (HEIGHT - coinHeight) / 2, coinWidth, coinHeight)];
    self.coinImgV.image = coinImage;
    [self addSubview:self.coinImgV];
    
    CGFloat subWidth = 150;
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.coinImgV) - 6.5 - subWidth, 0, subWidth, HEIGHT)];
    self.subLabel.textColor = RGB(230, 53, 40);
    self.subLabel.font = Font(15);
    self.subLabel.textAlignment = 2;
    [self addSubview:self.subLabel];
    
    self.subLabel.text = model.reward;
}

- (void)initcomPleteImgV:(CGFloat)HEIGHT {
    CGFloat completeHeight = 20;
    UIImage *completeImage = [UIImage imageNamed:@"已完成"];
    CGFloat completeWidth = completeImage.size.width / completeImage.size.height * completeHeight;
    self.coinImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 30 - 12 - completeWidth, (HEIGHT - completeHeight) / 2, completeWidth, completeHeight)];
    self.coinImgV.image = completeImage;
    [self addSubview:self.coinImgV];
}

- (void)initTitleLabelAndNextImgV:(CGFloat)HEIGHT model:(HHTaskSectionHeaderModel *)model {
    self.lineTop = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 0.5, HEIGHT / 2)];
    self.lineTop.backgroundColor = RGB(230, 230, 230);
    [self addSubview:self.lineTop];
    
    CGFloat height = 10;
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(X(self.lineTop) - height / 2, HEIGHT / 2 - height / 2, height, height)];
    self.imgView.image = [UIImage imageNamed:@"indicator_1"];
    [self addSubview:self.imgView];
    
    self.lineBottom = [[UIView alloc] initWithFrame:CGRectMake(X(self.lineTop), HEIGHT / 2, 0.5, HEIGHT / 2)];
    self.lineBottom.backgroundColor = self.lineTop.backgroundColor;
    [self addSubview:self.lineBottom];
    
    if (model.type == 1) {
        self.lineTop.hidden = YES;
    } else if (model.type == 3) {
        self.lineBottom.hidden = YES;
    } else {
        self.lineTop.hidden = NO;
        self.lineBottom.hidden = NO;
    }
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 12, 0, KWIDTH * 0.5, HEIGHT)];
    self.titleLabel.font = Font(16);
    self.titleLabel.textColor = BLACK_51;
    self.titleLabel.text = model.title;
    [self addSubview:self.titleLabel];
    
    
    CGFloat imgWidth =  model.open ? 15.0f : 8.0f;
    UIImage *image = [UIImage imageNamed:model.open ? @"open_down":@"item_view_right_arrow"];
    CGFloat imgHeight = image.size.height / image.size.width * imgWidth;
    self.nextImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 12 - imgWidth, HEIGHT / 2 - imgHeight / 2, imgWidth, imgHeight)];
    self.nextImgV.image = image;
    [self addSubview:self.nextImgV];
}





@end

//
//  HHMineMyInvitedCodeTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineMyInvitedCodeTableViewCell.h"
#import "UIImage+RoundedRectImage.h"
#import "CGQRCodeUtil.h"

@interface HHMineMyInvitedCodeTableViewCell ()

@property (nonatomic, strong)UIImageView *qrcodeImgV;

@property (nonatomic, strong)UIImageView *backImgV;

@property (nonatomic, strong)UILabel *myInLabel;

@property (nonatomic, strong)UILabel *codeLabel;

@property (nonatomic, strong)UIImageView *copInImgV;


@property (nonatomic, strong)UIImage *qrImage;

@end

@implementation HHMineMyInvitedCodeTableViewCell

#define HEIGHT CGFLOAT(150)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    self.qrImage = nil;
    
    CGFloat pad = 20;
    CGFloat topPad = 20;
    
    CGFloat qrImgWidth = HEIGHT - topPad * 2;
    self.qrcodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(pad, topPad, qrImgWidth, qrImgWidth)];
    self.qrcodeImgV.userInteractionEnabled = YES;
    [self.qrcodeImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQRCode)]];
    [self.contentView addSubview:self.qrcodeImgV];
    
    CGFloat backX = MaxX(self.qrcodeImgV) + 20;
    self.backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(backX, Y(self.qrcodeImgV), KWIDTH - backX - pad, HEIGHT - topPad * 2)];
    self.backImgV.image = [UIImage imageNamed:@"news_version_code"];
    [self.contentView addSubview:self.backImgV];
    
    
    
    CGFloat copyImgHeight = CGFLOAT(28);
    CGFloat copyBottom = 15;
    UIImage *copyImg = [UIImage imageNamed:@"copy_invite_code_bg"];
    CGFloat copeImgWidth = copyImg.size.width / copyImg.size.height * copyImgHeight;
    self.copInImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT - topPad - copyBottom  - copyImgHeight, copeImgWidth, copyImgHeight)];
    self.copInImgV.image = copyImg;
    self.copInImgV.center = CGPointMake(self.backImgV.center.x, self.copInImgV.center.y);
    self.copInImgV.userInteractionEnabled = YES;
    [self.copInImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyClick)]];
    [self.contentView addSubview:self.copInImgV];
    
    
    CGFloat myInLabelHeight = 15;
    NSString *text = @"我的邀请码";
    self.myInLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.copInImgV), self.backImgV.center.y - 5 - myInLabelHeight, [HHFontManager sizeWithText:text font:Font(14) maxSize:CGSizeMake(MAXFLOAT, myInLabelHeight)].width, myInLabelHeight)];
    self.myInLabel.text = text;
    self.myInLabel.font = Font(14);
    self.myInLabel.textColor = BLACK_153;
    [self.contentView addSubview:self.myInLabel];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.myInLabel), Y(self.myInLabel), W(self.copInImgV) - W(self.myInLabel), 15)];
    self.codeLabel.textColor = BLACK_51;
    self.codeLabel.font = Font(18);
    self.codeLabel.textAlignment = 2;
    [self.contentView addSubview:self.codeLabel];
    
    
    
    
}

- (void)setInvitedCode:(NSString *)invitedCode {
    
    _invitedCode = invitedCode;
    if (!invitedCode) {
        return;
    }
    NSString *url = [k_appstore_link stringByAppendingString:[NSString stringWithFormat:@"#code=%@",invitedCode]];
    [self createQRCodeImage:url];
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:invitedCode attributes:@{NSKernAttributeName:@2.0f}];
    self.codeLabel.attributedText = attStr;
}

- (void)createQRCodeImage:(NSString *)source {
    
    
    CIImage *imgQRCode = [CGQRCodeUtil createQRCodeImage:source];
    //使用核心绘图框架CG（Core Graphics）对象操作（图片大小适合，清晰，效果好）
    UIImage *imgAdaptiveQRCode = [CGQRCodeUtil resizeQRCodeImage:imgQRCode withSize:KWIDTH];
    ///加颜色
//    imgAdaptiveQRCode = [CGQRCodeUtil specialColorImage:imgAdaptiveQRCode withRed:33.0 green:114.0 blue:237.0];
    ///小图
    UIImage *imgIcon = [UIImage imageNamed:@"new_ic_launcher"];
    ///合并两张图
    CGFloat scale = 0.20;
    imgAdaptiveQRCode = [CGQRCodeUtil addIconToQRCodeImage:imgAdaptiveQRCode withIcon:imgIcon withIconSize:CGSizeMake(KWIDTH * scale, KWIDTH * scale)];
    
    self.qrcodeImgV.image = imgAdaptiveQRCode;
    self.qrImage = imgAdaptiveQRCode;
    
    
}


- (void)clickQRCode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickQRCode:)]) {
        [self.delegate clickQRCode:self.qrImage];
    }
}

- (void)copyClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCopy:)]) {
        [self.delegate clickCopy:self.invitedCode];
    }
}


@end

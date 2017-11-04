//
//  HHMineBigQRCodeView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineBigQRCodeView.h"

@interface HHMineBigQRCodeView ()

@property (nonatomic, strong)UIImageView *qrImgV;

@property (nonatomic, strong)UILabel *label;

@end

@implementation HHMineBigQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
                          img:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        
        [self initUI:frame img:image];
        self.frame = CGRectMake(X(self), Y(self), W(self), MaxY(self.label) + 30);
    }
    return self;
}

- (void)initUI:(CGRect)frame
           img:(UIImage *)img
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    CGFloat leftPad = 20;
    CGFloat topPad = 30;
    CGFloat width = frame.size.width;
    self.qrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(leftPad, topPad, width - leftPad * 2, width - leftPad * 2)];
    self.qrImgV.image = img;
    [self addSubview:self.qrImgV];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(X(self.qrImgV), MaxY(self.qrImgV) + 10, W(self.qrImgV), 15)];
    self.label.text = @"扫描二维码，下载惠头条或成为师徒";
    self.label.font = Font(14);
    self.label.textAlignment = 1;
    self.label.textColor = HUIRED;
    [self addSubview:self.label];
    
}




@end

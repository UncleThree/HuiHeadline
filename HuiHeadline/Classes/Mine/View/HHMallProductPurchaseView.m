//
//  HHMallProductPurchaseView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallProductPurchaseView.h"

@interface HHMallProductPurchaseView ()

@property (nonatomic, strong)UILabel *saleCreditLabel;

@property (nonatomic, strong)UIButton *convertButton;

@end

@implementation HHMallProductPurchaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}

- (void)setProduct:(HHProductOutline *)product {
    _product = product;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：%@金币", [HHUtils insertComma:[NSString stringWithFormat:@"%zd",product.salePrice]]] attributes:@{KEY_COLOR:RGB(230, 53, 40),KEY_FONT:Font(18)}];
    [attStr addAttribute:KEY_FONT value:Font(14) range:NSMakeRange(0, 3)];
    self.saleCreditLabel.attributedText = attStr;
    
}

- (void)initUI:(CGRect)frame
{
    
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    CGFloat height = frame.size.height;
    self.saleCreditLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH / 2, height)];
    [self addSubview:self.saleCreditLabel];
    
    CGFloat buttonWidth = CGFLOAT(111);
    CGFloat buttonHeight = CGFLOAT(42);
    self.convertButton = [[UIButton alloc] initWithFrame:CGRectMake(KWIDTH - 20 - buttonWidth, (height - buttonHeight) / 2, buttonWidth, buttonHeight)];
    self.convertButton.titleLabel.font = Font(18);
//    self.convertButton.layer.cornerRadius = 5;
    [self.convertButton setTitle:@"立即兑换" forState:(UIControlStateNormal)];
    self.convertButton.backgroundColor = HUIRED;
    [self.convertButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self addSubview:self.convertButton];
    
    [self.convertButton addTarget:self action:@selector(purchase) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)purchase {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mallpurchaseViewPurchase:)]) {
        [self.delegate mallpurchaseViewPurchase:self.product];
    }
    
}

@end

//
//  HHMineTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineTableViewCell.h"


@implementation HHMineTableViewCell

#define HEIGHT_CELL 85

{
    NSArray *array;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (G.$.bs) {
            return self;
        }
        CGFloat width = KWIDTH / 4;
        CGFloat height =  HEIGHT_CELL;
        array = @[@"商城兑换",@"我的订单",@"师徒邀请",@"收益明细"];
        for (int i = 0 ; i < array.count ; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tag = i + 99;
            button.frame = CGRectMake(width * i, 0, width, height);
            button.center = CGPointMake(button.center.x, HEIGHT_CELL / 2.0);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            UIView *backView = [[HHMineImageAndLabelView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:array[i] text:array[i] plumAward:NO];
            backView.userInteractionEnabled = NO;
            [button addSubview:backView];
            [self.contentView addSubview:button];
            
            if (i == 2) {
                
                [self initImgV:backView];
            }
        }
        
    }
    return self;
    
}

- (void)initImgV:(UIView *)superView {
    
    CGFloat height = 17;
    UIImage *image = [UIImage imageNamed:@"高额奖励"];
    CGFloat width = image.size.width / image.size.height * height;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX(superView), 8, width, height)];
    imgView.image = image;
    
    [superView addSubview:imgView];
}

- (void)buttonClick:(UIButton *)button {
    
    NSString *string = array[button.tag - 99];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HHMineTableViewCellDidClickButtonText:)]) {
        
        [self.delegate HHMineTableViewCellDidClickButtonText:string];
    }
    
}



@end

@interface HHMineImageAndLabelView ()

@property (nonatomic, strong)UIImageView *imgView;

@property (nonatomic, strong)UILabel *label;


@end

@implementation HHMineImageAndLabelView


- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                         text:(NSString *)text
                    plumAward:(BOOL)plumAward{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat imgWidth = 27;
        CGFloat real_height = imgWidth + 18 + 10;
        CGFloat y = (frame.size.height - real_height) / 2;
        
        UIImage *image = [UIImage imageNamed:imageName];
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, imgWidth, imgWidth)];
        self.imgView.image = image;
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.center = CGPointMake(self.center.x, centerY(self.imgView));
        
        [self addSubview:self.imgView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.imgView) + 10, frame.size.width, 18)];
        self.label.text = text;
        self.label.font = Font(15);
        self.label.textAlignment = 1;
        self.label.textColor = BLACK_51;
        [self addSubview:self.label];
        
    }
    return self;
    
}

@end









/*
 self.scdhView = [UIButton buttonWithType:UIButtonTypeCustom];
 self.scdhView.frame = CGRectMake(0, padding, width, height);
 [self.scdhView addSubview:[[HHMineImageAndLabelView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:@"商城兑换" text:@"商城兑换" plumAward:NO]];
 [self.contentView addSubview:self.scdhView];
 
 self.wdddView = [UIButton buttonWithType:UIButtonTypeCustom];
 self.wdddView.frame = CGRectMake(width * 1, padding, width, height);
 [self.wdddView addSubview:[[HHMineImageAndLabelView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:@"我的订单" text:@"我的订单" plumAward:NO]];
 [self.contentView addSubview:self.wdddView];
 
 self.styqView = [UIButton buttonWithType:UIButtonTypeCustom];
 self.styqView.frame = CGRectMake(width * 2, padding, width, height);
 [self.styqView addSubview:[[HHMineImageAndLabelView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:@"师徒邀请" text:@"师徒邀请" plumAward:NO]];
 [self.contentView addSubview:self.styqView];
 
 self.symxView = [UIButton buttonWithType:UIButtonTypeCustom];
 self.symxView.frame = CGRectMake(width * 3, padding, width, height);
 [self.symxView addSubview:[[HHMineImageAndLabelView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageName:@"收益明细" text:@"收益明细" plumAward:NO]];
 [self.contentView addSubview:self.symxView];
 */


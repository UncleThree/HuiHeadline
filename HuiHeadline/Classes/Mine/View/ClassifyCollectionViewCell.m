//
//  ClassifyCollectionViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "ClassifyCollectionViewCell.h"

@interface ClassifyCollectionViewCell ()

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)UIImageView *imgV;

@end

@implementation ClassifyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}

- (void)initUI:(CGRect)frame {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.label.textAlignment = 1;
    self.label.textColor = BLACK_153;
    self.label.font = Font(18);
//    self.label.layer.cornerRadius = 4;
    self.label.layer.borderWidth = 1;
    self.label.layer.borderColor = BLACK_153.CGColor;
    [self.contentView addSubview:self.label];
    
    UIImage *image = [UIImage imageNamed:@"xuanzhong"];
    CGFloat height = 20;
    CGFloat width = image.size.width / image.size.height * height;
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.label) - width, MaxY(self.label) - height, width, height)];
    self.imgV.image = image;
    [self.contentView addSubview:self.imgV];
    
}

- (void)setModel:(ClassifyModel *)model {
    
    if (!model) {
        return;
    }
    _model = model;
    self.label.text = model.text;
    self.imgV.hidden = !model.select;
    self.label.layer.borderColor = model.select ? HUIRED.CGColor : BLACK_153.CGColor;
    
}




@end

@implementation ClassifyModel

@end

//
//  HHTaskTableViewHeaderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskTableViewHeaderView.h"

@interface HHTaskTableViewHeaderView ()

@property (nonatomic, strong)UIView *redLine;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation HHTaskTableViewHeaderView

#define HEIGHT 50

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame title:title] ;
    }
    return self;
}

- (void)initUI:(CGRect)frame
         title:(NSString *)title{
    
    CGFloat width = 3;
    CGFloat height = 16;
    self.redLine = [[UIView alloc] initWithFrame:CGRectMake(12, (HEIGHT - height) / 2, width, height)];
    self.redLine.backgroundColor = HUIRED;
    [self addSubview:self.redLine];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.redLine) + 8, 0, 100, HEIGHT)];
    self.titleLabel.font = Font(17);
    self.titleLabel.text = title;
    self.titleLabel.textColor = BLACK_51;
    [self addSubview:self.titleLabel];
    
}

@end

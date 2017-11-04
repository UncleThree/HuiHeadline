//
//  HHeadlineAwardView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHeadlineAwardView.h"

@interface HHeadlineAwardView ()

@property (nonatomic, strong)UIImageView *imgV;

@property (nonatomic, strong)UILabel *label;

@end

@implementation HHeadlineAwardView


- (instancetype)initWithFrame:(CGRect)frame
                        coins:(NSInteger)coins
                    imageName:(NSString *)imageName{
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame coins:coins imageName:imageName];
    }
    return self;
    
    
}

- (void)initUI:(CGRect)frame
         coins:(NSInteger)coins
     imageName:(NSString *)imageName{
    
    self.imgV = ({
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:frame];
        imgV.image = [UIImage imageNamed:imageName];
        imgV.center = self.center;
        imgV;
    });
    
    self.label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.font = Font(25);
        label.center = CGPointMake(self.center.x, self.center.y - KWIDTH / 35);
        label.text = [NSString stringWithFormat:@"%zd", coins];
        label.textAlignment = 1;
        label.textColor = [UIColor redColor];
        label;
    });
    [self addSubview:self.imgV];
    [self addSubview:self.label];
   
    
}



@end

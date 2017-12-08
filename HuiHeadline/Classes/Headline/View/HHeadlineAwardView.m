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

@property (nonatomic, strong)UILabel *taskLabel;

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
        label.font = big_font(32);
        label.center = CGPointMake(self.center.x, self.center.y - CGFLOAT_W(15));
        if (coins != 0) {
            label.text = [NSString stringWithFormat:@"%zd", coins];
        }
        label.textAlignment = 1;
        label.textColor = [UIColor redColor];
        label;
    });
    [self addSubview:self.imgV];
    [self addSubview:self.label];
    if ([imageName isEqualToString:@"领取成功"]) {
        [self.label removeFromSuperview];
        self.taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.imgV) - 30, W(self.imgV), 20)];
        
        NSString *str = [NSString stringWithFormat:@"领取成功 +%zd",coins];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{KEY_FONT:Font(16),KEY_COLOR:HUIRED}];
        [string addAttribute:KEY_COLOR value:RGB(254, 237, 56) range:[str rangeOfString:@"领取成功"]];
        self.taskLabel.attributedText = string;
        self.taskLabel.textAlignment = 1;
        [self addSubview:self.taskLabel];
    }
   
    
}



@end

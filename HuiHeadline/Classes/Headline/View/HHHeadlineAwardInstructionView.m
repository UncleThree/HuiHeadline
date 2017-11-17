//
//  HHHeadlineAwardInstructionView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineAwardInstructionView.h"


@interface HHHeadlineAwardInstructionView ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)UIButton *leftButton;

@property (nonatomic, strong)UIButton *iKnowButton;




@end

@implementation HHHeadlineAwardInstructionView


- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      message:(NSString *)messge
                         left:(NSString *)left
                        right:(NSString *)right
                       target:(id)target
                  rightTarget:(id)rightTarget
                   leftAction:(SEL)leftAction
                   rightAction:(SEL)rightAction{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUIWithFrame:frame title:title message:messge left:left right:right target:target rightTarget:(id)rightTarget  leftAction:leftAction rightAction:rightAction];

    }
    return self;
    
}

- (void)initUIWithFrame:(CGRect)frame
                  title:(NSString *)title
            message:(NSString *)messge
               left:(NSString *)left
              right:(NSString *)right
             target:(id)target
        rightTarget:(id)rightTarget
         leftAction:(SEL)leftAction
        rightAction:(SEL)rightAction {
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = BLACK_51;
        label.font = Font(20);
        label;
    });
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:messge attributes:@{KEY_FONT:Font(17),KEY_COLOR:RGB(66, 66, 66)}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [messge length])];
        [string addAttribute:KEY_COLOR value:HUIRED range:[messge rangeOfString:@"“视频详情页”"]];
        label.attributedText = string;
        label.numberOfLines = 0;
        label;
    });
    
    self.leftButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:left forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:BLACK_51 forState:UIControlStateNormal];
        [[button titleLabel] setFont:Font(19)];
        [button addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
        button;
        
    });
    
    self.iKnowButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:right forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:HUIRED forState:UIControlStateNormal];
        [[button titleLabel] setFont:Font(19)];
        [button addTarget:rightTarget action:rightAction forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    if (left) {
        self.leftButton.hidden = NO;
    } else {
        self.leftButton.hidden = YES;
    }
    if (right) {
        self.iKnowButton.hidden = NO;
    } else {
        self.iKnowButton.hidden = YES;
    }
    [self addSubview:self.leftButton];
    [self addSubview:self.iKnowButton];
    
    
    [self layout:frame];
    
}



- (void)layout:(CGRect)frame {
    
    CGFloat padding = CGFLOAT(24);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self).with.offset(CGFLOAT(28));
        make.height.mas_equalTo(20);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.center.equalTo(self);
        make.right.equalTo(self).with.offset(-padding);
        
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(padding);
        make.bottom.equalTo(self).with.offset(CGFLOAT(-27));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(frame.size.width / 2 - padding);
    }];
    
    [self.iKnowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-padding);
        make.bottom.equalTo(self).with.offset(CGFLOAT(-27));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(frame.size.width / 2 - padding);
    }];
    
    
}


@end

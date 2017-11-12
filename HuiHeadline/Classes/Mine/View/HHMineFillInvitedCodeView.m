//
//  HHMineFillInvitedCodeView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/7.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineFillInvitedCodeView.h"
#import "QRViewController.h"





@interface HHMineFillInvitedCodeView ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UITextField *codeTF;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UIImageView *qrcodeImgV;

@property (nonatomic, strong)UIButton *submitButton;




@end

@implementation HHMineFillInvitedCodeView

- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action1
                      action2:(SEL)action2
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUIWithFrame:frame target:target action1:action1 action2:action2];
        
    }
    return self;
    
}

- (void)initUIWithFrame:(CGRect)frame
                 target:(id)target
                action1:(SEL)action1
                action2:(SEL)action2
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"填写邀请码";
        label.textColor = BLACK_51;
        label.font = Font(20);
        label;
    });
    
    self.codeTF = ({
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = @"输入师傅的邀请码";
//        tf.delegate = target;
        tf;
        
    });
    
    self.lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = BLACK_51;
        view;
    });
    
    self.qrcodeImgV = ({
        UIImageView *imgV = [UIImageView new];
        imgV.image = [UIImage imageNamed:@"icon_qr_code_scan"];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action2]];
        imgV;
    });
    
    
    self.submitButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:HUIRED forState:UIControlStateNormal];
        [[button titleLabel] setFont:Font(19)];
        [button addTarget:target action:action1 forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.codeTF];
    [self addSubview:self.lineView];
    [self addSubview:self.qrcodeImgV];
    [self addSubview:self.submitButton];
    
    
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
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).with.offset(-padding);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self).with.offset(-padding);
        make.bottom.equalTo(self.codeTF);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.qrcodeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView);
        make.bottom.equalTo(self.lineView.mas_top).with.offset(-3);
        make.width.and.height.mas_equalTo(25);
    }];
    
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-padding);
        make.bottom.equalTo(self).with.offset(CGFLOAT(-27));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(frame.size.width / 2 - padding);
    }];
    
    
}


@end

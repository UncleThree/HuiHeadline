//
//  HHRegistViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHRegistViewController.h"
#import <CoreText/CoreText.h>

@interface HHRegistViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *numberTF;
@property (nonatomic, strong) UITextField *virifyTF;
@property (nonatomic, strong) UITextField *passTF;
@property (nonatomic, strong) UITextField *inviteTF;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;


@property (nonatomic, strong) UILabel *virifyLabel;

@property (nonatomic, strong) UIButton *registButton;

@property (nonatomic, strong) UILabel *protocolLabel;

@end

@implementation HHRegistViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initUI];
    
}

- (void)initNavigation {
    
    UIBarButtonItem *backImg = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回(3)"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backImg.tintColor = BLACK_51;
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    back.tintColor = BLACK_51;
   
    
    self.navigationItem.leftBarButtonItems = @[backImg];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HUIRED;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"注册惠头条" attributes:@{NSForegroundColorAttributeName:HUIRED}];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:26]} range:NSMakeRange(0, 2)];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26]} range:NSMakeRange(2,3)];
        label.attributedText = attStr;

        label;
    });
    self.registButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        kButton_setAttr_normalState(button, @"注册", UIColor.whiteColor, K_Font(20));
        button.backgroundColor = HUIRED;
        button.layer.cornerRadius = 5.0;
        button;
    });
    self.protocolLabel = ({
        UILabel *label = [[UILabel alloc] init];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"点击注册，即表示您已阅读并同意用户协议" attributes:@{NSFontAttributeName:Font(14), NSForegroundColorAttributeName:BLACK_153}];
        [att addAttributes:@{KEY_COLOR:HUIRED} range:NSMakeRange(att.string.length - 4, 4)];
        label.attributedText = att;
        label.textAlignment = 1;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProtocol:)]];
        label;
    });
    [self initTf];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.numberTF];
    [self.view addSubview:self.virifyTF];
    [self.view addSubview:self.passTF];
    [self.view addSubview:self.inviteTF];
    
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    [self.view addSubview:self.line4];
    
    //virifyLabel
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.protocolLabel];
    
    [self layout];
    
    
}

//显示用户协议界面
- (void)showUserProtocol:(UIGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self.protocolLabel];
    NSUInteger length =  self.protocolLabel.text.length;
    CGFloat charWidth = W(self.protocolLabel) / length;
    CGFloat index = point.x  / charWidth;
    if (index >= length - 4  && index <= length - 1 ) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户协议" message:@"待处理" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void)initTf {
    self.numberTF = [[UITextField alloc] init];
    self.virifyTF = [[UITextField alloc] init];
    self.passTF   = [[UITextField alloc] init];
    self.inviteTF = [[UITextField alloc] init];
    
    self.line1 = [[UIView alloc] init];
    self.line2 = [[UIView alloc] init];
    self.line3 = [[UIView alloc] init];
    self.line4 = [[UIView alloc] init];
    
    NSArray *tfs = @[self.numberTF, self.virifyTF, self.passTF, self.inviteTF];
    NSArray *lines = @[self.line1,self.line2, self.line3, self.line4];
    NSArray *places = @[@"输入手机号",@"您的验证码",@"密码(6-20位数字或英文)",@"输入邀请码(选填,应用内可补填)"];
    for (int i = 0; i < tfs.count; i++) {
        UITextField *tf = tfs[i];
        tf.borderStyle = UITextBorderStyleNone;
        tf.font = Font(18);
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.tintColor = HUIRED;
        //different
        tf.keyboardType = i == 2 ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        tf.placeholder = places[i];
        tf.secureTextEntry = i == 2;
        
        UIView *line = lines[i];
        line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    
}

- (void)layout {
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(CGFLOAT(36));
        make.centerX.equalTo(self.view);
    }];
    
    [self.numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(CGFLOAT(50));
        make.left.equalTo(self.view).with.offset(34);
        make.right.equalTo(self.view).with.offset(-34);
        
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.numberTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self.numberTF);
        
    }];
    
    [self.virifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberTF.mas_bottom).with.offset(CGFLOAT(50));
        make.left.equalTo(self.numberTF);
        make.width.equalTo(self.numberTF);
        
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.virifyTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self.numberTF);
        
    }];
    
    [self.passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.virifyTF.mas_bottom).with.offset(CGFLOAT(50));
        make.left.equalTo(self.numberTF);
        make.width.equalTo(self.numberTF);
        
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self.numberTF);
        
    }];
    
    [self.inviteTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passTF.mas_bottom).with.offset(CGFLOAT(50));
        make.left.equalTo(self.numberTF);
        make.width.equalTo(self.numberTF);
        
    }];
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.inviteTF.mas_bottom).with.offset(10);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self.numberTF);
        
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line4.mas_bottom).with.offset(CGFLOAT(50));
        make.left.right.equalTo(self.numberTF);
        make.height.mas_equalTo(45);
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-25);
        make.centerX.equalTo(self.view);
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.numberTF resignFirstResponder];
    [self.virifyTF resignFirstResponder];
    [self.passTF resignFirstResponder];
    [self.inviteTF resignFirstResponder];
}



@end

//
//  HHRetrievePasswordViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//


#import "HHRetrievePasswordViewController.h"
#import "HHTextFieldAndLineView.h"

@interface HHRetrievePasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)HHTextFieldAndLineView *phoneTF;

@property (nonatomic, strong)HHTextFieldAndLineView *verifyTF;

@property (nonatomic, strong)HHTextFieldAndLineView *passwordTF;

@property (nonatomic, strong)UILabel *verifyLabel;

@property (nonatomic, strong)UIButton *bindPhoneButton;

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation HHRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)initNavigation {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 找回密码"];
    [self.view addSubview:self.navigationView];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initUI {
    
    UIFont *font = Font(15);
    
    CGFloat leftPad = 36;
    CGFloat topPad = CGFLOAT(40);
    self.phoneTF = [[HHTextFieldAndLineView alloc] initWithFrame:(CGRectMake(leftPad, MaxY(self.navigationView) + topPad, KWIDTH - 2 * leftPad, 40))];
    self.phoneTF.textField.placeholder = @"输入手机号";
    self.phoneTF.textField.tintColor = BLACK_153;
    self.phoneTF.textField.font = font;
    self.phoneTF.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.textField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.phoneTF];
    
    self.verifyTF = [[HHTextFieldAndLineView alloc] initWithFrame:(CGRectMake(leftPad, MaxY(self.phoneTF) + 20, KWIDTH - 2 * leftPad, 40))];
    self.verifyTF.textField.placeholder = @"您的验证码";
    self.verifyTF.textField.tintColor = BLACK_153;
    self.verifyTF.textField.font = font;
    self.verifyTF.textField.returnKeyType = UIReturnKeyDone;
    self.verifyTF.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyTF.textField.delegate = self;
    [self.view addSubview:self.verifyTF];
    
    self.passwordTF = [[HHTextFieldAndLineView alloc] initWithFrame:(CGRectMake(leftPad, MaxY(self.verifyTF) + 20, KWIDTH - 2 * leftPad, 40))];
    self.passwordTF.textField.placeholder = @"输入密码";
    self.passwordTF.textField.tintColor = BLACK_153;
    self.passwordTF.textField.font = font;
    self.passwordTF.textField.returnKeyType = UIReturnKeyDone;
    self.passwordTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTF.textField.delegate = self;
    [self.view addSubview:self.passwordTF];
    
    CGFloat labelWidth = 100;
    self.verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.phoneTF) - labelWidth, Y(self.phoneTF), labelWidth, 20)];
    self.verifyLabel.center = CGPointMake(self.verifyLabel.center.x, self.phoneTF.center.y);
    self.verifyLabel.font = Font(14);
    self.verifyLabel.textAlignment = 2;
    if (self.countdown) {
        [self verifyLabelEnabled:NO];
    } else {
        [self verifyLabelEnabled:YES];
    }
    self.verifyLabel.userInteractionEnabled = YES;
    [self.verifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerifyCode)]];
    [self.view addSubview:self.verifyLabel];
    
    
    self.bindPhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(leftPad, MaxY(self.passwordTF) + CGFLOAT(30), W(self.phoneTF), 40)];
    self.bindPhoneButton.backgroundColor = HUIRED;
    [self.bindPhoneButton setTitle:@"找回密码" forState:(UIControlStateNormal)];
    self.bindPhoneButton.layer.cornerRadius = 5;
    self.bindPhoneButton.tintColor = [UIColor whiteColor];
    [self.bindPhoneButton addTarget:self action:@selector(bindPhoneAgainAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.bindPhoneButton];
    
    
}

- (void)bindPhoneAgainAction {
    
    if (!self.phoneTF.textField.text || [self.phoneTF.textField.text isEqualToString:@""]) {
        [HHHeadlineAwardHUD showMessage:@"请输入手机号!" animated:YES duration:2.0];
    } else if (![HHUtils isMobileNumber:self.phoneTF.textField.text]) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入正确的手机号!" animated:YES duration:2.0];
        
    }
    else if (!self.verifyTF.textField.text || [self.verifyTF.textField.text isEqualToString:@""]) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入验证码!" animated:YES duration:2.0];
        
    } else if (!self.passwordTF.textField.text|| [self.passwordTF.textField.text isEqualToString:@""]) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入密码!" animated:YES duration:2.0];
    } else {
        
        [HHHeadlineAwardHUD showHUDWithText:@"正在找回密码" animated:YES];
        
        [HHMineNetwork retrievePasswordWithPhone:self.phoneTF.textField.text password:self.passwordTF.textField.text verifyCode:self.verifyTF.textField.text callback:^(id error, HHStateResponse *response) {
            [HHHeadlineAwardHUD hideHUDAnimated:YES];
            if (error) {
                NSLog(@"%@",error);
                [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
            } else if (response.statusCode == 200) {
                [HHHeadlineAwardHUD showMessage:response.msg ?:@"绑定成功！" animated:YES duration:2];
                
                [self.navigationController popViewControllerAnimated:YES];
                self.callback(response.msg);
                
            } else {
                [HHHeadlineAwardHUD showMessage:response.msg animated:YES duration:2];
            }
            
        }];
        
    }
    
}



- (void)verifyLabelEnabled:(BOOL)enabled {
    
    if (enabled) {
        self.verifyLabel.text = @"获取验证码";
        self.verifyLabel.textColor = HUIRED;
        self.verifyLabel.userInteractionEnabled = YES;
    } else {
        self.verifyLabel.text = [NSString stringWithFormat:@"%zds",self.countdown];
        self.verifyLabel.textColor = BLACK_153;
        self.verifyLabel.userInteractionEnabled = NO;
    }
}

- (void)getVerifyCode {
    
    if (self.phoneTF.textField.text.length == 0) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入手机号码" animated:YES duration:2.0];
        
    } else if (![HHUtils isMobileNumber:self.phoneTF.textField.text]) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入正确的手机号码" animated:YES duration:2.0];
        
    } else {
        
        self.countdown = 60;
        [self startTimer];
        
        [self sendSms:self.phoneTF.textField.text];
        
    }
    
}

- (void)sendSms:(NSString *)phone {
    
    [HHLoginNetwork sendSms:phone type:(SendSmsTypeRETRIEVE_PASSWORD) handler:^(NSString *msg, id error) {
        self.verifyLabel.userInteractionEnabled = YES;
        if (error) {
            Log(error);
        } else {
            [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2.0];
            
        }
    }];
}



- (void)startTimer {
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
    
}

- (void)timerAction {
    self.countdown--;
    if (self.countdown < 0 || self.countdown > 60) {
        return;
    }
    if (self.countdown == 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self verifyLabelEnabled:YES];
    } else {
        [self verifyLabelEnabled:NO];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual: self.verifyTF]) {
        [self getVerifyCode];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.phoneTF resignFirstResponder];
    [self.verifyTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}



@end








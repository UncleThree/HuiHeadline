//
//  HHMineChangePasswordViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineChangePasswordViewController.h"
#import "HHTextFieldAndLineView.h"

@interface HHMineChangePasswordViewController ()

@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)HHTextFieldAndLineView *oldPasTF;

@property (nonatomic, strong)HHTextFieldAndLineView *nePasTF;

@property (nonatomic,strong)HHTextFieldAndLineView *confirmTF;

@property (nonatomic, strong)UIButton *submitButton;


@end

@implementation HHMineChangePasswordViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initNavigation];
    [self initUI];
    
}

- (void)initNavigation {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 修改密码"];
    [self.view addSubview:self.navigationView];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    
    
    
    CGFloat pad = 20;
    
    self.view.backgroundColor = RGB(241, 241, 241);
    self.oldPasTF  = [[HHTextFieldAndLineView alloc] initWithFrame:CGRectMake(pad, MaxY(self.navigationView) + 20, KWIDTH - pad * 2, 40)];
    self.oldPasTF.textField.placeholder = @"请输入旧密码";
    self.oldPasTF.textField.font = Font(15);
    self.oldPasTF.textField.textColor = BLACK_51;
    self.oldPasTF.textField.returnKeyType = UIReturnKeyDone;
    self.oldPasTF.textField.tintColor = BLACK_153;
    self.oldPasTF.textField.secureTextEntry = YES;
    [self.view addSubview:self.oldPasTF];
    
    self.nePasTF  = [[HHTextFieldAndLineView alloc] initWithFrame:CGRectMake(pad, MaxY(self.oldPasTF) + 20, KWIDTH - pad * 2, 40)];
    self.nePasTF.textField.placeholder = @"请输入新密码";
    self.nePasTF.textField.font = Font(15);
    self.nePasTF.textField.textColor = BLACK_51;
    self.nePasTF.textField.returnKeyType = UIReturnKeyDone;
    self.nePasTF.textField.secureTextEntry = YES;
    self.nePasTF.textField.tintColor = BLACK_153;
    [self.view addSubview:self.nePasTF];
    
    self.confirmTF  = [[HHTextFieldAndLineView alloc] initWithFrame:CGRectMake(pad, MaxY(self.nePasTF) + 20, KWIDTH - pad * 2, 40)];
    self.confirmTF.textField.placeholder = @"请确认新密码";
    self.confirmTF.textField.font = Font(15);
    self.confirmTF.textField.textColor = BLACK_51;
    self.confirmTF.textField.returnKeyType = UIReturnKeyDone;
    self.confirmTF.textField.secureTextEntry = YES;
    self.confirmTF.textField.tintColor = BLACK_153;
    [self.view addSubview:self.confirmTF];
    
    
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(pad, MaxY(self.confirmTF) + CGFLOAT(30), W(self.oldPasTF), 40)];
    self.submitButton.backgroundColor = HUIRED;
    [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    self.submitButton.layer.cornerRadius = 8;
    self.submitButton.tintColor = [UIColor whiteColor];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.submitButton];
}

- (void)submit {
    
    if (!self.oldPasTF.textField.text) {
        
        [HHHeadlineAwardHUD showMessage:@"请输入旧密码" animated:YES duration:2];
    } else if (!self.nePasTF.textField.text) {
        [HHHeadlineAwardHUD showMessage:@"请输入新密码" animated:YES duration:2];
        
    } else if (![self.confirmTF.textField.text isEqualToString:self.nePasTF.textField.text]) {
        [HHHeadlineAwardHUD showMessage:@"两次输入密码不同！" animated:YES duration:2];
    } else {
        
        [HHHeadlineAwardHUD showHUDWithText:@"提交中，请稍后..." animated:YES];
        [HHLoginNetwork changePasswordWithOldPas:self.oldPasTF.textField.text newPassword:self.nePasTF.textField.text handler:^(id error, NSString *response) {
            [HHHeadlineAwardHUD hideHUDAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            self.callback(error ?: response);
        }];
        
        
    }
    
}


@end

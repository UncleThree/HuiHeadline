//
//  HHMineUserNickViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.

#import "HHMineUserNickViewController.h"


@interface HHMineUserNickViewController () <UITextFieldDelegate>

@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)UITextField *nickTextField;

@property (nonatomic, strong)UILabel *nickLabel;

@property (nonatomic, strong)UIButton *submitButton;

@end

@implementation HHMineUserNickViewController

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
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 昵称"];
    [self.view addSubview:self.navigationView];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    
    
    
    self.view.backgroundColor = RGB(241, 241, 241);
    self.nickTextField  = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nickTextField.placeholder = @"请输入您的新昵称";
    self.nickTextField.font = Font(15);
    self.nickTextField.textColor = BLACK_51;
    self.nickTextField.delegate = self;
    self.nickTextField.returnKeyType = UIReturnKeyDone;
    self.nickTextField.tintColor = BLACK_153;
    self.nickTextField.text = self.nickName;
    [self.view addSubview:self.nickTextField];
    
    self.nickLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
    self.nickLabel.text = @"取个好名字可以让生活都变的棒棒哒哦...";
    self.nickLabel.textColor = BLACK_153;
    self.nickLabel.font = Font(15);
    
    [self.view addSubview:self.nickLabel];
    
    self.submitButton = [[UIButton alloc] initWithFrame:(CGRectZero)];
    self.submitButton.backgroundColor = HUIRED;
    self.submitButton.layer.cornerRadius = 5;
    [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.submitButton];
    
    [self layout];
    
    
}

- (void)layout {
    
    CGFloat pad = 20;
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(pad);
        make.right.equalTo(self.view).with.offset(-pad);
        make.height.mas_equalTo(25);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickTextField.mas_bottom).with.offset(10);
        make.left.equalTo(self.nickTextField);
        make.width.and.height.equalTo(self.nickTextField);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickLabel.mas_bottom).with.offset(CGFLOAT(40));
        make.left.equalTo(self.view).with.offset(pad);
        make.right.equalTo(self.view).with.offset(-pad);
        make.height.mas_equalTo(35);
    }];
}

- (void)submit {
    
    if ([self.nickTextField.text isEqualToString:@""]) {
        
        [HHHeadlineAwardHUD  showMessage:@"输入的昵称不能为空" animated:YES duration:1];
        
    } else if (self.nickTextField.text.length > 8) {
        
        [HHHeadlineAwardHUD  showMessage:@"昵称不能长于8位!" animated:YES duration:1];
        
    }   else {
        
        [HHMineNetwork updateNickName:self.nickTextField.text];
        
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.nickTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self submit];
    [self.nickTextField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nickTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 8) {
            return NO;
        }
    }
    
    return YES;
}

@end

//
//  HHLoginViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHLoginViewController.h"
#import "HHRegistViewController.h"
#import "HHRootViewController.h"
#import "WechatService.h"
#import "AlipayService.h"
#import "HHRetrievePasswordViewController.h"

@interface HHLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *registLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirLabel;

@property (nonatomic, strong)UIImageView *wechatImgV;
@property (nonatomic, strong)UIImageView *alipayImgv;


@end

@implementation HHLoginViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
   
}



- (void)initUI {
    
    
    self.titleLabel.textColor = HUIRED;
    
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.tintColor = BLACK_153;
    
    if (HHUserManager.sharedInstance.userName.length) {
        
        self.userNameTextField.text = HHUserManager.sharedInstance.userName;
        
    }
    
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.tintColor = BLACK_153;
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.clipsToBounds = YES;
    self.loginButton.backgroundColor = HUIRED;
    [self.loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.registLabel.userInteractionEnabled = YES;
    [self.registLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registClick)]];
    self.forgetPasswordLabel.userInteractionEnabled = YES;
    [self.forgetPasswordLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordClick)]];
    
    self.wechatImgV = ({
        UIImageView *wechat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"微信"]];
        wechat.contentMode = UIViewContentModeScaleAspectFill;
        wechat.clipsToBounds = YES;
        wechat;
    });
    
    self.alipayImgv = ({
        UIImageView *alipay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"支付宝"]];
        alipay.contentMode = UIViewContentModeScaleAspectFill;
        alipay.clipsToBounds = YES;
        alipay;
    });
    [self.bottomView addSubview:self.wechatImgV];
    [self.bottomView addSubview:self.alipayImgv];
    
    self.wechatImgV.userInteractionEnabled = YES;
    [self.wechatImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginByWechat)]];
    
    self.alipayImgv.userInteractionEnabled = YES;
    [self.alipayImgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginByAli)]];
    
    [self layout];
    
    
   
    
}

- (void)loginByWechat {
    
    [HHHeadlineAwardHUD showHUDWithText:@"前往微信授权" addToView:self.view animated:YES timeout:8];
    
    [[WechatService sharedWechat] loginToWechat:^(id error, id result) {
        
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (result) {
            
            [HHLoginNetwork requestBSJson:^(BOOL bs) {
                G.$.rootVC = [HHRootViewController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = G.$.rootVC;
            }];
        
            
        } else {
            
            [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
        }
    }];
    
}

- (void)loginByAli {
    
    [HHHeadlineAwardHUD showHUDWithText:@"前往支付宝授权" addToView:self.view animated:YES timeout:8];
    [[AlipayService sharedAlipay] loginToAli:^(id error, id result) {
        
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (result) {
            
            [HHLoginNetwork requestBSJson:^(BOOL bs) {
                G.$.rootVC = [HHRootViewController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = G.$.rootVC;
            }];
        }  else {
            
            [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
        }
    }];
    
    
}

- (void)layout {
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        CGFloat topPad = CGFLOAT(80);
        if (KHEIGHT < 500) {
            topPad = 30;
        }
        make.top.equalTo(self.view).with.offset(topPad);
    }];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGFLOAT(180));
    }];
    
    [self.wechatImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.thirLabel.mas_bottom).with.offset(CGFLOAT(30));
        make.width.height.mas_equalTo(CGFLOAT(60));
        make.right.equalTo(self.view.mas_centerX).with.offset(-21);
    }];
    
    [self.alipayImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirLabel.mas_bottom).with.offset(CGFLOAT(30));
        make.width.height.mas_equalTo(self.wechatImgV);
        make.left.equalTo(self.view.mas_centerX).with.offset(21);
        
    }];
    
    
}

- (void)loginClick {
    
    
    if (!self.userNameTextField.text || [self.userNameTextField.text isEqualToString:@""] || !self.passwordTextField.text || [self.passwordTextField.text isEqualToString:@""] ) {
        [HHHeadlineAwardHUD showMessage:@"用户名或密码为空" hideTouch:NO animated:YES duration:2];
        return;
    }
    
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text];
    
    
    
}

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password {

    
    [HHHeadlineAwardHUD  showHUDWithText:@"请稍后" animated:YES timeout:8];
    [HHLoginNetwork loginRequestWithPhone:username password:password handler:^(NSString *respondsStr, id error) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (respondsStr) {
            
            HHUserManager.sharedInstance.userName = username;
            
            [HHLoginNetwork requestBSJson:^(BOOL bs) {
                
                G.$.rootVC = [HHRootViewController new];
                UIApplication.sharedApplication.keyWindow.rootViewController = G.$.rootVC;
                
            }];
            
        } else {
            NSLog(@"----login error----");
            
            [HHHeadlineAwardHUD showMessage:error hideTouch:NO animated:YES duration:2];
        }
        
        
    }];
    
}




- (void)registClick {
    //点击注册
    HHRegistViewController *registVC = [[HHRegistViewController alloc] init];
    registVC.callback = ^(NSError *error, id result) {
        if (error) {
            
        } else {
            
            [HHLoginNetwork requestBSJson:^(BOOL bs) {
                G.$.rootVC = [HHRootViewController new];
                UIApplication.sharedApplication.keyWindow.rootViewController = G.$.rootVC;
            }];
            
        }
    };
    [self.navigationController pushViewController:registVC animated:YES];
    
}

- (void)forgetPasswordClick {
    //点击忘记密码
    HHRetrievePasswordViewController *reVC = [HHRetrievePasswordViewController new];
    reVC.callback = ^(NSString *message) {
        
        [HHHeadlineAwardHUD showMessage:message animated:YES duration:2];
    };
    [self.navigationController pushViewController:reVC animated:YES];
    
    
}



@end

//
//  HHAboutHHViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/4.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHAboutHHViewController.h"
#import "HHActivityTaskDetailWebViewController.h"

@interface HHAboutHHViewController ()

 @property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)UIImageView *huiImgV;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *subTitleLabel;

@property (nonatomic, strong)UILabel *userProLabel;

@property (nonatomic, strong)UILabel *webLabel;

@end

@implementation HHAboutHHViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)initNav {
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 关于惠头条"];
    [self.view addSubview:self.navigationView];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initUI {
    
    CGFloat width = 80;
    self.huiImgV = [[UIImageView alloc] initWithFrame:CGRectMake((KWIDTH - width) / 2, MaxY(self.navigationView) + 40, width, width)];
    self.huiImgV.image = [UIImage imageNamed:@"huiheadline"];
    [self.view addSubview:self.huiImgV];
    
    
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.huiImgV) + 12, KWIDTH, 25)];
    self.versionLabel.textColor = BLACK_51;
    self.versionLabel.font = Font(15);
    self.versionLabel.textAlignment = 1;
    self.versionLabel.text = [NSString stringWithFormat:@"v%@",APP_VER_SHORT];
    [self.view addSubview:self.versionLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.versionLabel) + 16, KWIDTH, 20)];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.textColor = BLACK_51;
    self.titleLabel.text = @"会赚钱的头条";
    self.titleLabel.font = Font(19);
    [self.view addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.titleLabel) + 5, KWIDTH, 20)];
    self.subTitleLabel.textAlignment = 1;
    self.subTitleLabel.textColor = RGB(230, 53, 40);
    self.subTitleLabel.text = @"看资讯也可以赚钱";
    self.subTitleLabel.font = Font(13);
    [self.view addSubview:self.subTitleLabel];
    
    
    self.webLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KHEIGHT - 20 - 85, KWIDTH, 20)];
    self.webLabel.textAlignment = 1;
    self.webLabel.textColor = BLACK_51;
    self.webLabel.text = @"官网：www.cashtoutiao.com";
    self.webLabel.font = Font(13);
    [self.view addSubview:self.webLabel];
    self.webLabel.userInteractionEnabled = YES;
    [self.webLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoWebsite)]];
    
    self.userProLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(self.webLabel) - 20, KWIDTH, 20)];
    self.userProLabel.textAlignment = 1;
    self.userProLabel.textColor = BLACK_51;
    self.userProLabel.text = @"《用户使用条款和隐私协议》";
    self.userProLabel.font = Font(13);
    [self.view addSubview:self.userProLabel];
    self.userProLabel.userInteractionEnabled = YES;
    [self.userProLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserProtocol)]];
    
}

- (void)gotoUserProtocol {
    
    HHActivityTaskDetailWebViewController *webView = [HHActivityTaskDetailWebViewController new];
    webView.activityTitle = @"惠头条用户服务协议";
    webView.URLString = k_user_protocol;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:1];
    
}

- (void)gotoWebsite {
    
    HHActivityTaskDetailWebViewController *webView = [HHActivityTaskDetailWebViewController new];
    webView.activityTitle = @"惠头条官方网站";
    webView.URLString = @"http://www.cashtoutiao.com";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:1];
}



@end

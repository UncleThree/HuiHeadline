//
//  HHBaseViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/15.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHBaseViewController.h"
#import "HHDeviceUtils.h"
#import "Reachability.h"
#import <UMMobClick/MobClick.h>

@interface HHBaseViewController ()



@property (nonatomic, strong)UIImageView *imgV;

@property (nonatomic, strong)UILabel *noLinkLabel;


@end

@implementation HHBaseViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"onePiece"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"onePiece"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    if ([HHDeviceUtils formatConnectionType] == 0) {
   
        [self loadBackView];
        
        __weak AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status > 0) {
                [self refresh];
                [manager stopMonitoring];
            }
            
        }];
        
    }
    
}



- (void)loadBackView {
    
    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    [self.view addSubview:self.backView];
    [self.view bringSubviewToFront:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake( H(self.navigationView) , 0, 0, 0));
    }];
    self.backView.userInteractionEnabled = YES;
    [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)]];
    
    self.imgV = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"notice_robot"];
    self.imgV.image = image;
    [self.backView addSubview:self.imgV];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWIDTH / 3);
        make.height.mas_equalTo(image.size.height / image.size.width * KWIDTH / 3);
        make.centerX.equalTo(self.backView);
        make.centerY.equalTo(self.backView).with.offset(-20);
    }];
    
    self.noLinkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noLinkLabel.textColor = BLACK_153;
    self.noLinkLabel.textAlignment = 1;
    self.noLinkLabel.text = @"网络出错了，稍后再试吧";
    self.noLinkLabel.font = Font(15);
    [self.backView addSubview:self.noLinkLabel];
    [self.noLinkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgV.mas_bottom).with.offset(12);
        make.width.mas_equalTo(KWIDTH);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.backView);
    }];
    
    
}

- (void)refresh {
    
    if ([HHDeviceUtils formatConnectionType]) {
        if (self.backView)
            [self.backView removeFromSuperview];
    }
    
}






@end

//
//  HHMallSegmentViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallSegmentViewController.h"
#import "HHMallViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HHMallBindAliViewController.h"
#import "HHMallBindWechatViewController.h"
#import "HHOrderDetailViewController.h"
#import "HHMineBindPhoneViewController.h"
#import "HHMineRebindPhoneViewController.h"

@interface HHMallSegmentViewController () <UIScrollViewDelegate,HHMallTableViewDelegate>



@property (nonatomic, strong)UISegmentedControl *segment;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)HHMallViewController *aliVC;
@property (nonatomic, strong)HHMallViewController *wechatVC;
@property (nonatomic, strong)HHMallViewController *callVC;

@end

@implementation HHMallSegmentViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            view.hidden = NO;
        }
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
    [super viewDidLoad];
}

- (void)initUI {
    
    [self initNavigation];
    
    [self initSegment];
    
    [self initScrollView];
    
//    self.fd_interactivePopDisabled = NO;
    
    
}


- (void)initScrollView {
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, Y(self.view) + H(self.view))];
    self.scrollView.contentSize = CGSizeMake(KWIDTH * self.segment.numberOfSegments, H(self.view));
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    [self initaliVC];
   
    [self initWechatView];
    
    [self initCallVC];
    
}

- (void)initaliVC {
    
    self.aliVC = [HHMallViewController new];
    self.aliVC.delegate = self;
    [self addChildViewController:self.aliVC];
    self.aliVC.view.frame = CGRectMake(0, 0, KWIDTH, H(self.view));
    [self.scrollView addSubview:self.aliVC.view];
    self.aliVC.category = VIRTUAL_WITHDRAW_TO_ALIPAY;
}

- (void)initWechatView {
    
    self.wechatVC = [HHMallViewController new];
    self.wechatVC.delegate = self;
    [self addChildViewController:self.wechatVC];
    self.wechatVC.view.frame = CGRectMake(KWIDTH, 0, KWIDTH, H(self.view));
    [self.scrollView addSubview:self.wechatVC.view];
    self.wechatVC.category = VIRTUAL_WITHDRAW_TO_WECHAT_WALLET;
}

- (void)initCallVC {
    self.callVC = [HHMallViewController new];
    self.callVC.delegate = self;
    [self addChildViewController:self.callVC];
    self.callVC.view.frame = CGRectMake(KWIDTH * 2, 0, KWIDTH, H(self.view));
    [self.scrollView addSubview:self.callVC.view];
    self.callVC.category = VIRTUAL_RECHARGE_PHONE_BILL;
}

- (void)initNavigation {
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[[UIImage imageNamed:@"btn_back_without_bg"] scaleToSize:CGSizeMake(15, 15)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSegment {
    
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[UISegmentedControl class]]) {
            [subView removeFromSuperview];
        }
    }
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"支付宝",@" 微信钱包 ",@"话费"]];
    CGFloat width = 200;
    
    self.segment.frame = CGRectMake((KWIDTH - width) / 2 , (H(self.navigationController.navigationBar) - H(self.segment)) / 2, width, 30);
    self.segment.apportionsSegmentWidthsByContent = YES;
    self.segment.tintColor = [UIColor clearColor];
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.segment setTitleTextAttributes:@{KEY_FONT:Font(17),KEY_COLOR:[UIColor colorWithWhite:0.5 alpha:1.0]} forState:(UIControlStateNormal)];
    [self.segment setTitleTextAttributes:@{KEY_FONT:Font(19),KEY_COLOR:[UIColor colorWithWhite:1.0 alpha:1.0]} forState:(UIControlStateSelected)];
    [self.navigationController.navigationBar addSubview:self.segment];
    
}

- (void)segmentAction:(UISegmentedControl *)segment {
    
    NSInteger index = segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(KWIDTH * index, 0) animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / KWIDTH;
    self.segment.selectedSegmentIndex = index;
    
}

#pragma mark setAccout

- (void)clickSetAccountCellCategory:(NSInteger)category {
    
    if (category == VIRTUAL_WITHDRAW_TO_ALIPAY) {
        
        HHMallBindAliViewController *bindAliVC = [[HHMallBindAliViewController alloc] init];
        bindAliVC.alipayAccount = [HHUserManager sharedInstance].alipayAccount;
        self.hidesBottomBarWhenPushed = YES;
        bindAliVC.callback = ^(NSString *msg){
            [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2];
            [self initScrollView];
        };
        [self.navigationController pushViewController:bindAliVC animated:YES];
    } else if (category == VIRTUAL_WITHDRAW_TO_WECHAT_WALLET) {
        
        HHMallBindWechatViewController *bindWxVC = [HHMallBindWechatViewController new];
        bindWxVC.weixinAccount = [HHUserManager sharedInstance].weixinAccount;
        self.hidesBottomBarWhenPushed = YES;
        bindWxVC.callback = ^(NSString *msg){
            [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2];
            [self initScrollView];
            [self.scrollView setContentOffset:CGPointMake(KWIDTH, 0) animated:NO];
        };
        [self.navigationController pushViewController:bindWxVC animated:YES];
    } else if (category == VIRTUAL_RECHARGE_PHONE_BILL) {
        
        NSString *phone = HHUserManager.sharedInstance.currentUser.userInfo.phone;
        UIViewController *vc = nil;
        void (^callback)(NSString *phone) = ^(NSString *phone) {
            [self initScrollView];
            [self.scrollView setContentOffset:CGPointMake(KWIDTH * 2, 0) animated:NO];
        };
        if (phone) {
            HHMineRebindPhoneViewController *rebindPhoneVC = [[HHMineRebindPhoneViewController alloc] init];
            rebindPhoneVC.callback = callback;
            vc = rebindPhoneVC;
            
        } else {
            HHMineBindPhoneViewController *bindPhoneVC = [[HHMineBindPhoneViewController alloc] init];
            bindPhoneVC.callback = callback;
            vc = bindPhoneVC;
        }
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}


- (void)alertSuccessActionWithOrderId:(NSInteger)orderId {
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换成功！" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"查看详情" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        HHOrderDetailViewController *orderDetailVC = [HHOrderDetailViewController new];
        orderDetailVC.orderId = orderId;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
        
    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即分享" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//
//    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
//    [alert addAction:action2];
    [alert addAction:action3];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end

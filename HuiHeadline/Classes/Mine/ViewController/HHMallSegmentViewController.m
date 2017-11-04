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

@interface HHMallSegmentViewController () <UIScrollViewDelegate,HHMallTableViewDelegate>



@property (nonatomic, strong)UISegmentedControl *segment;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)HHMallViewController *aliVC;
@property (nonatomic, strong)HHMallViewController *wechatVC;
@property (nonatomic, strong)HHMallViewController *callVC;

@end

@implementation HHMallSegmentViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            view.hidden = NO;
        }
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
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
    
}

- (void)initaliVC {
    
    self.aliVC = [HHMallViewController new];
    self.aliVC.delegate = self;
    [self addChildViewController:self.aliVC];
    self.aliVC.view.frame = CGRectMake(0, 0, KWIDTH, H(self.view));
    [self.scrollView addSubview:self.aliVC.view];
    self.aliVC.category = alipy_category;
}

- (void)initWechatView {
    
    self.wechatVC = [HHMallViewController new];
    [self addChildViewController:self.wechatVC];
    self.wechatVC.view.frame = CGRectMake(KWIDTH, 0, KWIDTH, H(self.view));
    [self.scrollView addSubview:self.wechatVC.view];
    self.wechatVC.category = wechat_category;
}

//- (void)initCallVC {
//    HHMallViewController *callVC = [HHMallViewController new];
//    [self addChildViewController:callVC];
//    callVC.view.frame = CGRectMake(KWIDTH * 2, 0, KWIDTH, H(self.view));
//    callVC.view.backgroundColor = [UIColor blueColor];
//    [self.scrollView addSubview:callVC.view];
//    self.callVC = callVC;
//}

- (void)initNavigation {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
}

- (void)initSegment {
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[UISegmentedControl class]]) {
            [subView removeFromSuperview];
        }
    }
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"支付宝",@"微信钱包"]];
    CGFloat width = 200;
    self.segment.frame = CGRectMake((KWIDTH - width) / 2 , (H(self.navigationController.navigationBar) - H(self.segment)) / 2, width, 30);
    self.segment.apportionsSegmentWidthsByContent = YES;
    self.segment.tintColor = [UIColor clearColor];
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.segment setTitleTextAttributes:@{KEY_FONT:Font(16),KEY_COLOR:[UIColor colorWithWhite:0.5 alpha:1.0]} forState:(UIControlStateNormal)];
    [self.segment setTitleTextAttributes:@{KEY_FONT:Font(16),KEY_COLOR:[UIColor colorWithWhite:1.0 alpha:1.0]} forState:(UIControlStateSelected)];
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
    
    if (category == alipy_category) {
        
        HHMallBindAliViewController *bindAliVC = [[HHMallBindAliViewController alloc] init];
        bindAliVC.alipayAccount = [HHUserManager sharedInstance].alipayAccount;
        self.hidesBottomBarWhenPushed = YES;
        bindAliVC.callback = ^{
            [self initScrollView];
        };
        [self.navigationController pushViewController:bindAliVC animated:YES];
    }
    
    
    
}


@end

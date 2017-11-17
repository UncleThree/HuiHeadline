//
//  HHMyOrderSegmentViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyOrderSegmentViewController.h"
#import "HHMyOrderViewController.h"
#import "HHOrderDetailViewController.h"

@interface HHMyOrderSegmentViewController ()<WMPageControllerDataSource, MyOrderDelegate>

@property (nonatomic, strong)UIView *navigationView;

@end

@implementation HHMyOrderSegmentViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.itemNames = @[@"正在处理",@"全部订单"].mutableCopy;
        self.titleSizeNormal = 16.0;
        self.titleSizeSelected = 17.0;
        self.dataSource = self;
        self.delegate = self;
        self.menuViewStyle = WMMenuViewStyleLine;

    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
   
    
}


- (void)initNav {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 我的订单"];
    [self.view addSubview:self.navigationView];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WMPageControllerDataSource


- (NSArray<Class> *)viewControllerClasses {
    
    return @[[HHMyOrderViewController class],[HHMyOrderViewController class]];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.itemNames[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HHMyOrderViewController *orderVC = [HHMyOrderViewController new];
    orderVC.delegate = self;
    orderVC.type = index;
    return orderVC;
    
    
}

- (void)pushToOrderDetailVC:(HHOrderInfo *)orderInfo {
    
    HHOrderDetailViewController *orderDetailVC = [HHOrderDetailViewController new];
    orderDetailVC.orderId = orderInfo.orderId;
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    return CGRectMake(0, MaxY(self.navigationView), KWIDTH, 40);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    
    return KWIDTH / self.itemNames.count;
}




@end

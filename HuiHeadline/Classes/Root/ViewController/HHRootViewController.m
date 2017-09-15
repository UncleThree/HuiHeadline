//
//  HHRootViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHRootViewController.h"
#import "HHHeadlineNavController.h"
#import "HHHeadlineSegmentViewController.h"

@interface HHRootViewController ()


@end

@implementation HHRootViewController


- (instancetype)init {
    
    if (self = [super init]) {
        
        [self configGlobalUIStyle];
        
        UINavigationController *navi0 = [HHHeadlineSegmentViewController defaultSegmentVC];
        UINavigationController *navi1 = [UINavigationController new];
        UINavigationController *navi2 = [UINavigationController new];
        UINavigationController *vc3 = [UINavigationController new];
        CYLTabBarController *tbc = [CYLTabBarController new];
        [self customTabBarForController:tbc];
        [tbc setViewControllers:@[navi0,navi1,navi2,vc3]];
        self = (HHRootViewController *)tbc;
        self.tabBar.tintColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}

/** 配置导航栏 */
- (void)configGlobalUIStyle {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"backgroundImage"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
//    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


- (void)customTabBarForController:(CYLTabBarController *)tbc {
    NSDictionary *dict0 = @{CYLTabBarItemTitle:@"头条",
                            CYLTabBarItemImage:@"news",
                            CYLTabBarItemSelectedImage:@"newsblue"};
    NSDictionary *dict1 = @{CYLTabBarItemTitle:@"视频",
                            CYLTabBarItemImage:@"live",
                            CYLTabBarItemSelectedImage:@"liveblue"};
    NSDictionary *dict2 = @{CYLTabBarItemTitle:@"邀请",
                            CYLTabBarItemImage:@"market",
                            CYLTabBarItemSelectedImage:@"marketblue"};
    NSDictionary *dict3 = @{CYLTabBarItemTitle:@"我的",
                            CYLTabBarItemImage:@"my",
                            CYLTabBarItemSelectedImage:@"myblue"};
    NSArray *tabBarItemsAttributes = @[dict0,dict1,dict2,dict3];
    tbc.tabBarItemsAttributes = tabBarItemsAttributes;
    
}





@end

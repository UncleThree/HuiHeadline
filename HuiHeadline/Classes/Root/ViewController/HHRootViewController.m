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
#import "HHVideoSegmentViewController.h"
#import "HHMineViewController.h"
#import "HHTaskCenterViewController.h"
#import "HHLoginViewController.h"

@interface HHRootViewController ()


@end

@implementation HHRootViewController


- (instancetype)init {
    
    if (self = [super init]) {
        
        [self configGlobalUIStyle];
        
        UINavigationController *navi0 = [HHHeadlineSegmentViewController defaultSegmentVC];
        UINavigationController *navi1 = [HHVideoSegmentViewController    defaultSegmentVC];
        UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:[HHTaskCenterViewController defaultTaskCenterVC]];
        UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:[HHMineViewController defaultMineVC]];
        
        CYLTabBarController *tbc = [CYLTabBarController new];
        [self customTabBarForController:tbc];
        [tbc setViewControllers:@[navi0,navi1,navi2,navi3]];
        self = (HHRootViewController *)tbc;
        self.tabBar.tintColor = [UIColor redColor];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAppAfterCheckLogin];
    
}

- (void)initAppAfterCheckLogin {
    
    ///请求阅读规则
    [HHLoginNetwork requestReadConfig];
    ///检查时段奖励
    [[HHHeadlineSegmentViewController defaultSegmentVC] checkHourAward];
    ///刷新我的信息页面
    [[HHMineViewController defaultMineVC] realoadHeaderData];
    ///刷新签到配置
    [[HHTaskCenterViewController defaultTaskCenterVC] reloadHeader:YES];
}


/** 配置导航栏 */
- (void)configGlobalUIStyle {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"backgroundImage"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
//    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

}


- (void)customTabBarForController:(CYLTabBarController *)tbc {
    NSArray *titles = @[@"头条", @"视频", @"任务中心", @"我的"];
    NSMutableArray *tabBarItemsAttributes = [NSMutableArray array];
    for (NSString *title in titles) {
        NSDictionary *dict =  @{CYLTabBarItemTitle:title,
                              CYLTabBarItemImage:title,
                              CYLTabBarItemSelectedImage:[title stringByAppendingString:@"_点击"]};
        [tabBarItemsAttributes addObject:dict];
    }
    tbc.tabBarItemsAttributes = tabBarItemsAttributes.copy;
    
}





@end

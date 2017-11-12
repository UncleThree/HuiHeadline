//
//  HHMainViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineViewController.h"
#import "HHMineNetwork.h"
#import "HHMineTableViewCell.h"
#import "HHMineNormalTableViewCell.h"
#import "HHMineNetwork.h"
#import "HHMineViewController+TableView.h"
#import "HHMineSettingViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface HHMineViewController ()<HHMineHeaderViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end


static HHMineViewController *mineVC = nil;



@implementation HHMineViewController



#define HEADER_HEIGHT CGFLOAT(200)

+ (instancetype)defaultMineVC {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mineVC = [[self class] new];
    });
    return mineVC;
   
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
//        NSArray *array = @[@"我的消息",@"红包福利",@"联系客服",@"常见问题"];
        NSArray *array = @[@"清除缓存",@"检查更新",@"给惠头条评分",@"用户服务协议",@"关于惠头条"];
        for (int i = 0 ; i < array.count; i++) {
            HHMineNormalCellModel *model = [[HHMineNormalCellModel alloc] init];
//            if (i == 0) { // && 有新消息
//                model.hasNew = YES;
//                model.redText = @"新消息";
//            }
//            if (i == 1) {
//                model.hasSub = YES;
//                model.subText = @"一言不合就发钱";
//            }
            model.text = array[i];
            model.imgName = array[i];
            [_models addObject:model];
        }
    }
    return _models;
}

- (NSMutableArray<HHMineNormalCellModel *> *)settingModels {
    if (!_settingModels) {
        _settingModels = [NSMutableArray array];
        HHMineNormalCellModel *model = [[HHMineNormalCellModel alloc] init];
     
        model.hasNew = YES;
        model.redText = @"新版本";
        model.text = @"系统设置";
        model.imgName = @"系统设置";
        [_settingModels addObject:model];
        
    }
    return _settingModels;
}

- (void)initHeaderView {
    self.headerView = nil;
    self.headerView = [[HHMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, HEADER_HEIGHT) user:[HHUserManager sharedInstance].currentUser summary:[HHUserManager sharedInstance].creditSummary];
    self.headerView.delegate = self;
    [self.tableView reloadData];
}

- (void)realoadHeaderData:(BOOL)requst {
    
    if (!requst) {
        
        [self initHeaderView];
    } else {
        [self requstCreditSummaryAndInitHeaderView];
    }
    
}

- (void)requstCreditSummaryAndInitHeaderView {
    
    
    [HHMineNetwork requestCreditSummary:^(id error, HHUserCreditSummary *summary) {
        
        if (error) {
            NSLog(@"requestCreditSummary:%@",error);
        } else {
            
            [HHUserManager sharedInstance].creditSummary = summary;
        }
        [self initHeaderView];
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:RGB(196, 57, 53)];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self realoadHeaderData:YES];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTableView];
    
    [self realoadHeaderData:NO];
    
//    [self requestBannerAd];
}

- (void)requestBannerAd {
    
    [HHMineNetwork requestAds:^(NSError *error, NSArray<HHAdModel *> *result) {
        
        if (error) {
            Log(error);
        } else {
            NSLog(@"banner ads : %@",result);
        }
        
    }];
}



- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.bounces = NO;
    self.tableView.sectionFooterHeight = 0;
    
    [self.tableView registerClass:[HHMineTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineTableViewCell class])];
    [self.tableView registerClass:[HHMineNormalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineNormalTableViewCell class])];
}

#pragma mark mineHeaderViewDelegate

- (void)mineHeaderViewDidClick {
    
    
    HHMineSettingViewController *settingVC = [[HHMineSettingViewController alloc] init];
    settingVC.callback = ^{
        [self realoadHeaderData:NO];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}





@end

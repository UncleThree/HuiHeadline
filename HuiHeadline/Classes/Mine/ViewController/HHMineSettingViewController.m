//
//  HHMineSettingViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineSettingViewController.h"
#import "HHMineSettingTableViewCell.h"
#import "HHMineSettingCellModel.h"
#import "HHMineUserheadPortraitViewController.h"
#import "HHMineUserNickViewController.h"
#import "HHMineBindPhoneViewController.h"
#import "HHMineUpdateGenderView.h"
#import "HHLoginViewController.h"

@interface HHMineSettingViewController ()<UITableViewDataSource, UITableViewDelegate, HHMineUpdateGenderViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray <HHMineSettingCellModel *> *userData;

@property (nonatomic, strong)NSMutableArray <HHMineSettingCellModel *> *managerData;

@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)HHMineUpdateGenderView *genderView;

@end

@implementation HHMineSettingViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigation];
   
    [self initTableView];
}

- (void)initNavigation {
    

    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 设置"];
    [self.view addSubview:self.navigationView];
    
    
}


- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[HHMineSettingTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineSettingTableViewCell class])];
    [self.tableView registerClass:[HHMineSettingTableViewCell class] forCellReuseIdentifier:@"HEADER"];
}


- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray<HHMineSettingCellModel *> *)userData {
    
    if (!_userData) {
        _userData = [NSMutableArray array];
        HHUserInfo *userInfo = [HHUserManager sharedInstance].currentUser.userInfo;
        NSArray *textArray = @[@"头像",@"昵称",@"手机号",@"性别",@"生日",@"账户状态",@"修改密码"];
        for (int i = 0; i < textArray.count; i++) {
            HHMineSettingCellModel *model = [[HHMineSettingCellModel alloc] init];
            model.text = textArray[i];
            if (i == 0) {
                model.imageUrl = userInfo.headPortrait;
            }
            if ([textArray[i] isEqualToString:@"昵称"]) {
                model.subText = userInfo.nickName;
            } else if ([textArray[i] isEqualToString:@"手机号"]) {
                model.subText = userInfo.phone_sec;
            } else if ([textArray[i] isEqualToString:@"性别"]) {
                model.subText = userInfo.genderString;
            } else if ([textArray[i] isEqualToString:@"生日"]) {
                model.subText = userInfo.birthday;
            } else if ([textArray[i] isEqualToString:@"账户状态"]) {
                model.subText = @"正常";
            } else {
                model.subText = @"";
            }
            [_userData addObject:model];
        }
    }
    return _userData;
    
}

- (NSMutableArray<HHMineSettingCellModel *> *)managerData {
    
    if (!_managerData) {
        _managerData = [NSMutableArray array];
        
        NSArray *textArray = @[@"管理支付宝",@"管理微信钱包",@"管理收货地址"];
        for (int i = 0; i < textArray.count; i++) {
            HHMineSettingCellModel *model = [[HHMineSettingCellModel alloc] init];
            model.text = textArray[i];
            model.subText = @"";
            [_managerData addObject:model];
        }
    }
    return _managerData;
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7;
    } else if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMineSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineSettingTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setModel:self.userData[indexPath.row]];
    } else if (indexPath.section == 1) {
        [cell setModel:self.managerData[indexPath.row]];
    } else {
        HHMineSettingCellModel *model = [HHMineSettingCellModel new];
        model.text = @"退出登录";
        model.subText = @"";
        [cell setModel:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 75;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

kRemoveCellSeparator

#pragma  mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //修改用户信息成功后 修改currentUser
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed = YES;
        if        (indexPath.row == 0) {
            
            HHMineUserheadPortraitViewController *headPoraitVC = [[HHMineUserheadPortraitViewController alloc] init];
            headPoraitVC.url = [HHUserManager sharedInstance].currentUser.userInfo.headPortrait;
            [self.navigationController pushViewController:headPoraitVC animated:YES];
        } else if (indexPath.row == 1) {
            HHMineUserNickViewController *nickVC = [[HHMineUserNickViewController alloc] init];
            nickVC.nickName = [HHUserManager sharedInstance].currentUser.userInfo.nickName;
            [self.navigationController pushViewController:nickVC animated:YES];
        } else if (indexPath.row == 2) {
            HHMineBindPhoneViewController *bindPhoneVC = [[HHMineBindPhoneViewController alloc] init];
            bindPhoneVC.countdown = [HHUserManager sharedInstance].virifyCodeCountdown;
            [self.navigationController pushViewController:bindPhoneVC animated:YES];
        } else if (indexPath.row == 3) {
            if (!self.genderView) {
                self.genderView = [[HHMineUpdateGenderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) gender:[HHUserManager sharedInstance].currentUser.userInfo.genderString];
                self.genderView.delegate = self;
                
                [self.view addSubview:self.genderView];
            }
            self.genderView.hidden = NO;
            
        }
        
    } else if (indexPath.section == 1) {
        
    } else {
        
        HHUserManager.sharedInstance.currentUser = nil;
        UIApplication.sharedApplication.keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
    }
    
    
}


- (void)selectGender:(NSString *)gender {
    
    self.genderView.hidden = YES;
    NSLog(@"%@",gender);
    
}



@end

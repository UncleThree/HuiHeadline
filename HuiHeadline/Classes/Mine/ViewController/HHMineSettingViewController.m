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
#import "HHMineRebindPhoneViewController.h"
#import "HHMineUpdateGenderView.h"
#import "HHLoginViewController.h"
#import "HHMineBindPhoneViewController.h"
#import "HHMallBindAliViewController.h"
#import "HHMallBindWechatViewController.h"
#import "HHMineChangePasswordViewController.h"

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
    self.callback();
}


- (NSMutableArray<HHMineSettingCellModel *> *)userData {
    
    if (!_userData) {
        _userData = [NSMutableArray array];
        
    }
    [_userData removeAllObjects];
    HHUserInfo *userInfo = [HHUserManager sharedInstance].currentUser.userInfo;
//    NSArray *textArray = @[@"头像",@"昵称",@"手机号",@"性别",@"生日",@"账户状态",@"修改密码"];
    NSArray *textArray = @[@"昵称",@"手机号",@"性别",@"生日",@"账户状态",@"修改密码"];
    for (int i = 0; i < textArray.count; i++) {
        HHMineSettingCellModel *model = [[HHMineSettingCellModel alloc] init];
        model.text = textArray[i];
//        if (i == 0) {
//            model.imageUrl = userInfo.headPortrait;
//        }
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
    return _userData;
    
}

- (NSMutableArray<HHMineSettingCellModel *> *)managerData {
    
    if (!_managerData) {
        _managerData = [NSMutableArray array];
        
//        NSArray *textArray = @[@"管理支付宝",@"管理微信钱包",@"管理收货地址"];
        NSArray *textArray = @[@"管理支付宝",@"管理微信钱包"];
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
        return self.userData.count;
    } else if (section == 1) {
        return self.managerData.count;
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
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return 75;
//    }
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
//        if  (indexPath.row == 0) {
//
//            HHMineUserheadPortraitViewController *headPoraitVC = [[HHMineUserheadPortraitViewController alloc] init];
//            headPoraitVC.url = [HHUserManager sharedInstance].currentUser.userInfo.headPortrait;
//            [self.navigationController pushViewController:headPoraitVC animated:YES];
//        } else
        if (indexPath.row == 0) {
           
            [self pushUpdateNickVC];
            
        } else if (indexPath.row == 1) {
            
            [self updateBindPhone];
            
        } else if (indexPath.row == 2) {
            
            [self updateGender];
            
        } else if (indexPath.row == 3) {
            
            [self updateBirthday];
            
        } else if (indexPath.row == 4) {
            
            [self checkAccountState];
            
        } else if (indexPath.row == 5) {
            
            if ([HHUserManager sharedInstance].currentUser.userInfo.phone) {
                [self pushToChangePassword];
            } else {
                [self updateBindPhone];
            }
            
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            [self managerAliAcount];
            
        } else {
            
            [self managerWechatAccount];
        }
    } else {
        
        [self loginOutAlert];
    }
    
    
}


- (void)loginOutAlert {
    
    UIAlertAction *loginOutAction = [UIAlertAction actionWithTitle:@"退出登录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self loginOut];
    }];
    if ([HHUserManager sharedInstance].currentUser.userInfo.phone) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出登录后，您将不能持续获得阅读收益，确认退出吗？" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:loginOutAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续赚钱" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你尚未绑定手机号，退出登录有可能会导致账号丢失且无法找回，强烈建议你绑定手机号后再尝试退出操作" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:loginOutAction];
        UIAlertAction *bindPhoneAction = [UIAlertAction actionWithTitle:@"快速绑定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self updateBindPhone];
        }];
        [alert addAction:bindPhoneAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}


- (void)loginOut {
    
    HHUserManager.sharedInstance.currentUser = nil;
    UIApplication.sharedApplication.keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
}

- (void)pushToChangePassword {
    
    //修改密码
    HHMineChangePasswordViewController *changePas = [HHMineChangePasswordViewController new];
    self.hidesBottomBarWhenPushed = YES;
    changePas.callback = ^(NSString *msg) {
        [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2];
    };
    [self.navigationController pushViewController:changePas animated:YES];
}

- (void)managerWechatAccount {
    
    HHMallBindWechatViewController *bindWechatVC = [HHMallBindWechatViewController new];
    bindWechatVC.manager = YES;
    bindWechatVC.callback = ^(NSString *msg) {
        [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindWechatVC animated:YES];
}

- (void)managerAliAcount {
    
    HHMallBindAliViewController *bindAliVC = [HHMallBindAliViewController new];
    bindAliVC.manager = YES;
    bindAliVC.callback = ^(NSString *msg) {
        [HHHeadlineAwardHUD showMessage:msg animated:YES duration:2];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindAliVC animated:YES];
}

- (void)checkAccountState {
    
    [HHHeadlineAwardHUD showHUDWithText:@"正在提交，请稍后..." animated:YES];
    [HHLoginNetwork checkLogin:^(id error, NSString * result) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            NSLog(@"%@",result);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"账号状态" message:result preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:^{ }];
            
            
        }
    }];
    
}

- (void)pushUpdateNickVC {
    
    HHMineUserNickViewController *nickVC = [[HHMineUserNickViewController alloc] init];
    nickVC.nickName = [HHUserManager sharedInstance].currentUser.userInfo.nickName;
    nickVC.callback = ^(NSString *nickName) {
        
        HHUserModel *user = [HHUserManager sharedInstance].currentUser;
        user.userInfo.nickName = nickName;
        [HHUserManager sharedInstance].currentUser = user;
        [self.tableView reloadData];
        
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nickVC animated:YES];
}

- (void)updateBindPhone {
    
    if (HHUserManager.sharedInstance.currentUser.userInfo.phone && ![HHUserManager.sharedInstance.currentUser.userInfo.phone isEqualToString:@""]) {
        
        HHMineRebindPhoneViewController *bindPhoneVC = [[HHMineRebindPhoneViewController alloc] init];
        bindPhoneVC.callback = ^(NSString *phone) {
            
            HHUserModel *user = [HHUserManager sharedInstance].currentUser;
            user.userInfo.phone = phone;
            [HHUserManager sharedInstance].currentUser = user;
            [self.tableView reloadData];
        };
        bindPhoneVC.countdown = [HHUserManager sharedInstance].virifyCodeCountdown;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindPhoneVC animated:YES];
        
    } else {
        
        HHMineBindPhoneViewController *bindPhoneVC = [[HHMineBindPhoneViewController alloc] init];
        bindPhoneVC.callback = ^(NSString *phone) {
            
            HHUserModel *user = [HHUserManager sharedInstance].currentUser;
            user.userInfo.phone = phone;
            [HHUserManager sharedInstance].currentUser = user;
            [self.tableView reloadData];
        };
        bindPhoneVC.countdown = [HHUserManager sharedInstance].virifyCodeCountdown;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindPhoneVC animated:YES];
    }
}

- (void)updateGender {
    
    if (!self.genderView) {
        self.genderView = [[HHMineUpdateGenderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT) gender:[HHUserManager sharedInstance].currentUser.userInfo.genderString];
        self.genderView.delegate = self;
        [self.view addSubview:self.genderView];
    }
    self.genderView.hidden = NO;
}

- (void)updateBirthday {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    datePicker.center = CGPointMake(alert.view.center.x, datePicker.center.y);
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
        [HHHeadlineAwardHUD showHUDWithText:@"正在提交，请稍后..." animated:YES];
        [HHMineNetwork updateBirthday:dateString callback:^(id error, HHResponse *response) {
            [HHHeadlineAwardHUD hideHUDAnimated:YES];
            if (error) {
                NSLog(@"%@",error);
            } else {
                if (response.statusCode == 200) {
                    
                    HHUserModel *user = HHUserManager.sharedInstance.currentUser;
                    user.userInfo.birthday = dateString;
                    HHUserManager.sharedInstance.currentUser = user;
                    [self.tableView reloadData];
                    
                } else {
                    [HHHeadlineAwardHUD showMessage:response.msg animated:YES duration:2];
                }
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}


- (void)selectGender:(NSString *)gender {
    
    self.genderView.hidden = YES;
    
    [HHHeadlineAwardHUD showHUDWithText:@"正在提交，请稍后..." animated:YES];
    NSInteger genderShort = [gender isEqualToString:@"男"] ? 1 : 2;
    [HHMineNetwork  updateGender:genderShort callback:^(id error, HHResponse *response) {
        
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (error) {
            NSLog(@"%@",error);
        } else {
            if (response.statusCode == 200) {
                
                HHUserModel *user = HHUserManager.sharedInstance.currentUser;
                user.userInfo.gender = genderShort;
                HHUserManager.sharedInstance.currentUser = user;
                [self.tableView reloadData];
            } else {
                
                [HHHeadlineAwardHUD showMessage:response.msg animated:YES duration:2];
            }
        }
    }];
    
    
}



@end

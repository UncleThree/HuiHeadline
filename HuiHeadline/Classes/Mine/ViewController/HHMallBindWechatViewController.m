//
//  HHMallBindAliViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallBindWechatViewController.h"
#import "HHLabelAndTextFieldTableViewCell.h"
#import "HHWXAuthorizeTableViewCell.h"
#import "WechatService.h"

@interface HHMallBindWechatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *changeAliButton;

@property (nonatomic, strong)NSMutableArray<HHLabelAndTextFieldModel *> *models;

@property (nonatomic, strong)HHWXAuthorizeModel *wxModel;

@property (nonatomic, strong)UITextField *realNameTF;

@property (nonatomic, strong)UITextField *phoneTF;

@property (nonatomic, strong)UITextField *wechatNameTF;

@property (nonatomic, strong)UILabel *reminderLabel;

@end

@implementation HHMallBindWechatViewController

#define cell_height 50

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (UIButton *)changeAliButton {
    
    if (!_changeAliButton) {
        _changeAliButton = [[UIButton alloc] initWithFrame:CGRectMake(20, MaxY(self.tableView) + 25, KWIDTH - 40, 40)];
        [_changeAliButton addTarget:self action:@selector(saveOrChange:) forControlEvents:(UIControlEventTouchUpInside)];
        _changeAliButton.layer.cornerRadius = 5;
        _changeAliButton.backgroundColor = HUIRED;
        [self.view addSubview:_changeAliButton];
    }
    return _changeAliButton;
}

- (UILabel *)reminderLabel {
    if (!_reminderLabel) {
        _reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(self.changeAliButton) + 20, KWIDTH - 40, 80)];
        _reminderLabel.textColor = HUIRED;
        _reminderLabel.font = Font(15);
        _reminderLabel.numberOfLines = 0;
        [self.view addSubview:_reminderLabel];
    }
    return _reminderLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KWIDTH, cell_height * 3 + 10) style:(UITableViewStylePlain)];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        [_tableView registerClass:[HHLabelAndTextFieldTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHLabelAndTextFieldTableViewCell class])];
        [_tableView registerClass:[HHWXAuthorizeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHWXAuthorizeTableViewCell class])];
    }
    return _tableView;
}

- (void)setWeixinAccount:(HHWeixinAccount *)weixinAccount {
    
    _weixinAccount = weixinAccount;
    HHLabelAndTextFieldModel *model1 = [[HHLabelAndTextFieldModel alloc] init];
    model1.labelText = @"真实姓名";
    HHLabelAndTextFieldModel *model2 = [[HHLabelAndTextFieldModel alloc] init];
    model2.labelText = @"手机号码";
    if (weixinAccount.realName && weixinAccount.phone) {
        
        model1.tfText = weixinAccount.realName;
        model1.tfEnabled = NO;
        model2.tfText = weixinAccount.phone;
        model2.tfEnabled = NO;
        [self.changeAliButton setTitle:@"修改" forState:(UIControlStateNormal)];
    } else {
        model1.placeholder = @"请输入真实姓名";
        model1.tfEnabled = YES;
        model2.placeholder = @"请输入手机号码";
        model2.tfEnabled = YES;
        [self.changeAliButton setTitle:@"保存" forState:(UIControlStateNormal)];
    }
    self.reminderLabel.text = @"温馨提示：\n真实姓名，请填写微信绑定的银行卡的真实认证姓名";
    
    [self.models removeAllObjects];
    [self.models addObject:model1];
    [self.models addObject:model2];
    
    self.wxModel = [[HHWXAuthorizeModel alloc] init];
    self.wxModel.labelText = @"微信授权：";
    self.wxModel.authorized = weixinAccount.openId ? YES : NO;
    self.wxModel.wxName = weixinAccount.nickName;
    self.wxModel.headerUrl = weixinAccount.headPortrait;
    self.wxModel.enabled = weixinAccount ? NO : YES;
    
    
}


- (NSMutableArray<HHLabelAndTextFieldModel *> *)models {
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
            view.hidden = YES;
        }
    }
    
    if (self.manager) {
        [self requstDefaultWXAccount];
    }
    
}

- (void)requstDefaultWXAccount {
    
    [HHMineNetwork getDefaultWechat:^(id error, HHWeixinAccountResponse *response) {
        if (response) {
            HHUserManager.sharedInstance.weixinAccount = response.weixinAccount;
            [self setWeixinAccount:response.weixinAccount];
            
        }
        [self.tableView reloadData];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}

- (void)initNav {
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back) text:@" 管理微信钱包"]];
    self.view.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)saveOrChange:(UIButton *)button {
    
    if ([button.currentTitle isEqualToString:@"保存"]) {
        
        if (!self.realNameTF.text || [self.realNameTF.text isEqualToString:@""]) {
            [HHHeadlineAwardHUD showMessage:@"姓名不能为空！" animated:YES duration:2];
        } else if (!self.phoneTF.text || [self.phoneTF.text isEqualToString: @""]) {
            [HHHeadlineAwardHUD showMessage:@"手机号码不能为空！" animated:YES duration:2];
        } else if (![HHUtils isMobileNumber:self.phoneTF.text]) {
            [HHHeadlineAwardHUD showMessage:@"手机号码格式错误" animated:YES duration:2];
            
        } else if (![HHUtils isOnlyChinese:self.realNameTF.text]) {
            
            [HHHeadlineAwardHUD showMessage:@"姓名只能是中文" animated:YES duration:2];
            
        } else if (!self.weixinAccount.openId) {
            
            [HHHeadlineAwardHUD showMessage:@"没有授权信息" animated:YES duration:2];
            
        }   else {
            [HHHeadlineAwardHUD showHUDWithText:@"正在保存 请稍后" animated:YES];
            
            HHWeixinAccount *weixinAccount = [[HHWeixinAccount alloc] init];
            weixinAccount.realName = self.realNameTF.text;
            weixinAccount.phone = self.phoneTF.text;
            weixinAccount.openId = self.weixinAccount.openId;
            weixinAccount.headPortrait = self.weixinAccount.headPortrait;
            weixinAccount.nickName = self.weixinAccount.nickName;
            
            [HHMineNetwork updateWeixinAccountWithWxAccount:weixinAccount callback:^(id error, HHResponse *response) {
                
                [HHHeadlineAwardHUD hideHUDAnimated:YES];
                if (error) {
                    [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
                } else {
                    HHUserManager.sharedInstance.weixinAccount = weixinAccount;
                    [self.navigationController popViewControllerAnimated:YES];
                    self.callback(response.msg);
                }
                
            }];
            

            
        }
        
    } else if ([button.currentTitle isEqualToString:@"修改"]) {
        
        [self changeToSave:1];
        
    }
    
}

- (void)changeToSave:(BOOL)save {
    
    if (save) {
        self.models[0].tfEnabled = YES;
        self.models[1].tfEnabled = YES;
        [self.changeAliButton setTitle:@"保存" forState:(UIControlStateNormal)];
        self.wxModel.enabled = YES;
        [self.tableView reloadData];
    } else {
        self.models[0].tfEnabled = NO;
        self.models[1].tfEnabled = NO;
        [self.changeAliButton setTitle:@"修改" forState:(UIControlStateNormal)];
        [self.tableView reloadData];
    }
    
}




#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count + (self.wxModel ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        return 60;
    }
    return 50;
}

kRemoveCellSeparator

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        HHWXAuthorizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHWXAuthorizeTableViewCell class]) forIndexPath:indexPath];
        cell.model = self.wxModel;
        if (!self.wxModel.enabled) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        return cell;
        
    }
    HHLabelAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHLabelAndTextFieldTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        self.realNameTF = cell.textField;
    } else {
        self.phoneTF = cell.textField;
    }
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.realNameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        
        if (!self.wxModel.enabled) {
            return;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self wechatAuthorize];
        
    }
    
}

- (void)wechatAuthorize {
    
    
    [[WechatService sharedWechat] authorizeToWechat:^(id error, HHWeixinAccount *account) {
        if (error) {
            [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
        } else {
            
            [self setWeixinAccount:account];
            [self.tableView reloadData];
            
        }
    }];
}

@end


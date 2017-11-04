//
//  HHMallBindAliViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallBindWechatViewController.h"
#import "HHLabelAndTextFieldTableViewCell.h"


@interface HHMallBindWechatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *changeAliButton;

@property (nonatomic, strong)NSMutableArray<HHLabelAndTextFieldModel *> *models;

@property (nonatomic, strong)UITextField *accountTF;

@property (nonatomic, strong)UITextField *nameTF;

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KWIDTH, cell_height * 2) style:(UITableViewStylePlain)];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        [_tableView registerClass:[HHLabelAndTextFieldTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHLabelAndTextFieldTableViewCell class])];
        
    }
    return _tableView;
}

- (void)setWeixinAccount:(HHWeixinAccount *)weixinAccount {
    
    _weixinAccount = weixinAccount;
    HHLabelAndTextFieldModel *model1 = [[HHLabelAndTextFieldModel alloc] init];
    model1.labelText = @"真实姓名";
    HHLabelAndTextFieldModel *model2 = [[HHLabelAndTextFieldModel alloc] init];
    model2.labelText = @"手机号码";
    if (weixinAccount) {
        
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
    [self.models removeAllObjects];
    [self.models addObject:model1];
    [self.models addObject:model2];
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
        
        if (!self.accountTF.text || [self.accountTF.text isEqualToString:@""]) {
            [HHHeadlineAwardHUD showMessage:@"支付宝账户不能为空！" animated:YES duration:2];
        } else if (!self.nameTF.text || [self.nameTF.text isEqualToString: @""]) {
            [HHHeadlineAwardHUD showMessage:@"姓名不能为空！" animated:YES duration:2];
        } else if (![self accountMatchRule:self.accountTF.text]) {
            [HHHeadlineAwardHUD showMessage:@"支付宝账号只支持手机号和邮箱格式，否则无法支付成功！请仔细核对！" animated:YES duration:2];
        } else if (![HHUtils isOnlyChinese:self.nameTF.text]) {
            
            [HHHeadlineAwardHUD showMessage:@"姓名只能是中文" animated:YES duration:2];
            
        }   else {
            [HHHeadlineAwardHUD showHUDWithText:@"正在保存 请稍后" animated:YES];
            
            [HHMineNetwork updateAliAccount:self.accountTF.text name:self.nameTF.text callback:^(id error, HHResponse *response) {
                
                if (error) {
                    [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
                } else {
                    [HHUserManager sharedInstance].alipayAccount = [HHAlipayAccount mj_objectWithKeyValues:@{@"account":self.accountTF.text,@"name":self.nameTF.text}];
                    [HHHeadlineAwardHUD showMessage:response.msg animated:YES duration:2];
                    [self.navigationController popViewControllerAnimated:YES];
                    self.callback();
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
        [self.tableView reloadData];
    } else {
        self.models[0].tfEnabled = NO;
        self.models[1].tfEnabled = NO;
        [self.changeAliButton setTitle:@"修改" forState:(UIControlStateNormal)];
        [self.tableView reloadData];
    }
    
}


- (BOOL)accountMatchRule:(NSString *)account {
    
    return [HHUtils isEmailAddress:account] || [HHUtils isMobileNumber:account];
    
    
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHLabelAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHLabelAndTextFieldTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        self.accountTF = cell.textField;
    } else {
        self.nameTF = cell.textField;
    }
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.accountTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    
}


@end


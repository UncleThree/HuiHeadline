//
//  HHOrderDetailViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHOrderDetailViewController.h"
#import "HHMyOrderWarmReminderTableViewCell.h"
#import "HHUserDeliveryAddress.h"

@interface HHOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)HHOrderInfo *detailOrderInfo;

@end

static NSString *orderInfoCell = @"ORDER_DETAIL_INFO_CELL_ID";
static NSString *stateName = @"STATE_NAME_CELL_ID";
static NSString *payCreditCellId = @"PAY_CREDIT_CELL_ID";
static NSString *orderIdCellId = @"ORDER_ID_CELL_ID";
static NSString *orderAddress = @"ORDER_ADDRESS_CELL_ID";

@implementation HHOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self requestOrderDetail];
}

- (void)viewDidLoad {
    
    
    [self initNav];
    
    [self initTableView];
    
    [super viewDidLoad];
    
    
    
}

- (void)refresh {
    
    [super refresh];
    [self requestOrderDetail];
}
- (void)initNav {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 订单详情"];
    [self.view addSubview:self.navigationView];
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 10;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,_tableView.bounds.size.width,0.01f)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:orderInfoCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:stateName];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:payCreditCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:orderIdCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:orderAddress];
    [self.tableView registerClass:[HHMyOrderWarmReminderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMyOrderWarmReminderTableViewCell class])];
    
    
}

- (void)requestOrderDetail {
    
    if (!self.detailOrderInfo) {
        [HHHeadlineAwardHUD showHUDWithText:@"" animated:1];
    }
    [HHMineNetwork getOrderDetailInfo:self.orderId callback:^(id error, HHOrderInfo *orderInfo) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (error) {
            NSLog(@"%@",error);
        } else {
            self.detailOrderInfo = orderInfo;
            self.detailOrderInfo.isDetail = YES;
            [self.tableView reloadData];
        }
        
    }];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailOrderInfo) {
        return 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.detailOrderInfo ? 5 : 0;
    } else {
        return self.detailOrderInfo.feedback ? 1 : 0;
    }
}

kRemoveCellSeparator

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 120;
        } else if (indexPath.row == 3) {
            
            CGFloat height = [HHFontManager sizeWithText:[self addressString] font:Font(17) maxSize:CGSizeMake(KWIDTH - 24, CGFLOAT_MAX)].height + 20;
            return height < 45 ? 45 : height;
        }
    } else if (indexPath.section == 1) {
        
        if (self.detailOrderInfo.feedback) {
            
            CGFloat titleWidth = [HHFontManager sizeWithText:@"温馨提示：" font:Font(15) maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
            return [HHFontManager sizeWithText:self.detailOrderInfo.feedback font:Font(15) maxSize:CGSizeMake(KWIDTH - 40 - titleWidth - 5, CGFLOAT_MAX)].height + 20;
            
        } else {
            
            return 0;
        }
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateName forIndexPath:indexPath];
            cell.contentView.backgroundColor = HUIRED;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = self.detailOrderInfo.stateName;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = Font(15);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (indexPath.row == 1) {
            
            HHMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoCell forIndexPath:indexPath];
            cell.orderInfo = self.detailOrderInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (indexPath.row == 2) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateName forIndexPath:indexPath];
            cell.textLabel.text = self.detailOrderInfo.stateName;
            cell.textLabel.textColor = BLACK_51;
            cell.textLabel.font = Font(15);
            cell.textLabel.text = [NSString stringWithFormat:@"订单号：%zd", self.detailOrderInfo.orderId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderAddress forIndexPath:indexPath];
            cell.textLabel.text = self.detailOrderInfo.stateName;
            cell.textLabel.textColor = BLACK_51;
            cell.textLabel.font = Font(15);
            cell.textLabel.text = [self addressString];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payCreditCellId forIndexPath:indexPath];
            cell.textLabel.textAlignment = 2;
            NSString *totalCredit = nil;
            totalCredit = [HHUtils insertComma:self.detailOrderInfo.salePrice];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额：%@金币", totalCredit] attributes:@{KEY_FONT:Font(15),KEY_COLOR:HUIRED}];
            [attStr addAttribute:KEY_COLOR value:BLACK_153 range:NSMakeRange(0, 5)];
            cell.textLabel.attributedText = attStr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    } else {
        
        HHMyOrderWarmReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMyOrderWarmReminderTableViewCell class]) forIndexPath:indexPath];
        cell.feedback = self.detailOrderInfo.feedback;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
    return nil;
}

- (NSString *)addressString {
    
    if (self.detailOrderInfo) {
        NSString *tstr = nil;
        NSString *dstr = nil;
        if (self.detailOrderInfo.productCategory == VIRTUAL_WITHDRAW_TO_ALIPAY ) {
            tstr = @"支付宝：";
            NSString *account = [self.detailOrderInfo.address mj_JSONObject][@"account"];
            NSString *name = [self.detailOrderInfo.address mj_JSONObject][@"name"];
            dstr = [[account stringByAppendingString:@" "] stringByAppendingString:name];
        } else if (self.detailOrderInfo.productCategory == VIRTUAL_WITHDRAW_TO_WECHAT_WALLET) {
            tstr = @"微信钱包：";
            NSString *phone = [self.detailOrderInfo.address mj_JSONObject][@"phone"];
            NSString *realName = [self.detailOrderInfo.address mj_JSONObject][@"realName"];
            dstr = [[phone stringByAppendingString:@" "] stringByAppendingString:realName];
            
        } else if (self.detailOrderInfo.productCategory == REAL_CAREFULLY_CHOSEN_DAILY_NECCESSARY) {
            tstr = @"收货人：";
            HHUserDeliveryAddress *address = [HHUserDeliveryAddress mj_objectWithKeyValues:[self.detailOrderInfo.address mj_JSONObject]];
            dstr = [NSString stringWithFormat:@" %@\n%@%@%@%@",address.userPhone,address.addressProvince,address.addressCity,address.addressZone, address.addressStreet];
            
        } else if (self.detailOrderInfo.productCategory == VIRTUAL_RECHARGE_PHONE_BILL) {
            
            tstr = @"手机号码：";
            NSString *phone = self.detailOrderInfo.address;
            dstr = phone;
            
            
        } else {
            
            NSLog(@"暂未处理");
        }
        return [tstr stringByAppendingString:dstr];
        
    }
    return nil;
    
}



@end

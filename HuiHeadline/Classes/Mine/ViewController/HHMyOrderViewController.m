//
//  HHMyOrderViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyOrderViewController.h"
#import "HHMyOrderTableViewCell.h"
#import "HHMyOrderTitleTableViewCell.h"
#import "HHOrderDetailViewController.h"

@interface HHMyOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIImageView *noneImgV;

@property (nonatomic, strong)UILabel *noneLabel;

@property (nonatomic, strong)NSMutableArray<HHOrderInfo *> *disposingOrders;

@property (nonatomic, strong)NSMutableArray<HHOrderInfo *> *allOrders;

@end

static NSString *totalCreditCellIdentifier = @"totalCreditCellIdentifier";

@implementation HHMyOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initTableView];
    [self requestOrders];
}

- (void)initNoneView {
    
    CGFloat width = KWIDTH / 3;
    UIImage *image = [UIImage imageNamed:@"空状态"];
    CGFloat height = image.size.height / image.size.width * width;
    self.noneImgV = [[UIImageView alloc] initWithFrame:CGRectMake((KWIDTH - width) / 2, (H(self.view) - height ) / 2, width, height)];
    self.noneImgV.image = image;
    [self.view addSubview:self.noneImgV];
    
    self.noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(self.noneImgV), MaxY(self.noneImgV) + 5, W(self.noneImgV), 20)];
    self.noneLabel.textAlignment = 1;
    self.noneLabel.textColor = BLACK_153;
    self.noneLabel.text  = @"暂无订单";
    [self.view addSubview:self.noneLabel];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 10;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,_tableView.bounds.size.width,0.01f)];
    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HHMyOrderTableViewCell class])];
    [self.tableView registerClass:[HHMyOrderTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMyOrderTitleTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:totalCreditCellIdentifier];
}

- (NSMutableArray<HHOrderInfo *> *)allOrders {
    
    if (!_allOrders) {
        _allOrders = [NSMutableArray array];
    }
    return _allOrders;
}

- (NSMutableArray<HHOrderInfo *> *)disposingOrders {
    
    if (!_disposingOrders) {
        _disposingOrders = [NSMutableArray array];
    }
    return _disposingOrders;
}

- (void)requestOrders {
    
    [HHHeadlineAwardHUD showHUDWithText:nil animated:YES];
    [HHMineNetwork getOrderList:!self.type callback:^(id error, NSArray<HHOrderInfo *> *orders) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (error) {
            NSLog(@"%@",error);
            
        } else {
            if (!self.type) {
                [self.disposingOrders removeAllObjects];
                [self.disposingOrders addObjectsFromArray:orders];
            } else {
                [self.allOrders removeAllObjects];
                [self.allOrders addObjectsFromArray:orders];
            }
            
        }
        if (!orders.count) {
            self.tableView.hidden = YES;
            [self initNoneView];
        } else {
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.type == 0) {
        return self.disposingOrders.count;
    } else {
        return self.allOrders.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 45;
    } else if (indexPath.row == 1) {
        return 120;
    }
    return 45;
}

kRemoveCellSeparator


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        HHMyOrderTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMyOrderTitleTableViewCell class]) forIndexPath:indexPath];
        if (self.type) {
            cell.stateName = [self.allOrders[indexPath.section] stateName];
            cell.titleName = [self.allOrders[indexPath.section] channel] == 2 ? @"一元惠拍" : @"商城兑换";
        } else {
            cell.stateName = [self.disposingOrders[indexPath.section] stateName];
            cell.titleName = [self.disposingOrders[indexPath.section] channel] == 2 ? @"一元惠拍" : @"商城兑换";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        HHMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMyOrderTableViewCell class]) forIndexPath:indexPath];
        if (self.type) {
            cell.orderInfo = self.allOrders[indexPath.section];
        } else {
            cell.orderInfo = self.disposingOrders[indexPath.section];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:totalCreditCellIdentifier forIndexPath:indexPath];
        cell.textLabel.textAlignment = 2;
        NSString *totalCredit = nil;
        if (self.type) {
            totalCredit = [HHUtils insertComma:[self.allOrders[indexPath.section] salePrice]];
        } else {
            totalCredit = [HHUtils insertComma:[self.disposingOrders[indexPath.section] salePrice]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价：%@金币", totalCredit] attributes:@{KEY_FONT:Font(15),KEY_COLOR:HUIRED}];
        [attStr addAttribute:KEY_COLOR value:BLACK_153 range:NSMakeRange(0, 3)];
        cell.textLabel.attributedText = attStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return [UITableViewCell new];
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HHOrderInfo *orderInfo = nil;
    if (self.type) {
        orderInfo = self.allOrders[indexPath.section];
    } else {
        orderInfo = self.disposingOrders[indexPath.section];
    }
    HHOrderDetailViewController *orderDetailVC = [HHOrderDetailViewController new];
    orderDetailVC.orderId = orderInfo.orderId;
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}







@end

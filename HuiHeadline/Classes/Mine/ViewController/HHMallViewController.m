//
//  HHMallViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallViewController.h"
#import "HHMallBindTableViewCell.h"
#import "HHMineNormalCellModel.h"
#import "HHMallProductTableViewCell.h"
#import "HHMallProductPurchaseView.h"

@interface HHMallViewController () <UITableViewDataSource, UITableViewDelegate,HHMallProductTableViewCellDelegate,HHMallPurchaseViewDelegate>


@property (nonatomic, strong)HHMallProductPurchaseView *purchaseView;

@property (nonatomic, strong)HHMineNormalCellModel *firModel;

@property (nonatomic, strong)NSArray<HHProductOutline *> *products;

@property (nonatomic, strong)NSString *currentCredit;


@end

static NSString *currentCredit = @"CURRENT_CREDIT_CELL_IDENTIFIER";

static NSString *arrive_identifier = @"ARRIVE_TIME_IDENTIFIER";

@implementation HHMallViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initTableView];
}

- (void)setCategory:(NSInteger)category {
    
    _category = category;
    
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    [self getAccount:category callback:^{
        [self getCreditSummary:^{
            [self getProductList:category callback:^{
            
                [HHHeadlineAwardHUD hideHUDAnimated:YES];
                [self.tableView reloadData];
                
            }];
        }];
    }];
    
    
    
    
    
}

- (void)getAccount:(NSInteger)category
          callback:(void(^)())callback {
    
    if (category == alipy_category) {
        
        if ([HHUserManager sharedInstance].alipayAccount) {
            
            self.firModel = [HHMineNormalCellModel new];
            self.firModel.imgName = @"zhifubao";
            self.firModel.text = [NSString stringWithFormat:@"%@ %@", [HHUserManager sharedInstance].alipayAccount.account, [HHUserManager sharedInstance].alipayAccount.name];
            callback();
        } else {
            
            [HHMineNetwork getDefaultAlipay:^(id error, HHAlipayAccountResponse *response) {
                if (error) {
                    NSLog(@"%@",error);
                    [self defaultAli];
                } else {
                    [HHUserManager sharedInstance].alipayAccount = response.alipayAccount;
                    self.firModel = [HHMineNormalCellModel new];
                    self.firModel.imgName = @"zhifubao";
                    self.firModel.text = [NSString stringWithFormat:@"%@ %@", response.alipayAccount.account, response.alipayAccount.name];
                    
                }
                callback();
            }];
        }
    } else if (category == wechat_category) {
        
        if ([HHUserManager sharedInstance].weixinAccount) {
            
            self.firModel = [HHMineNormalCellModel new];
            self.firModel.imgName = @"icon_weixin";
            self.firModel.text = [NSString stringWithFormat:@"%@ %@", [HHUserManager sharedInstance].weixinAccount.phone, [HHUserManager sharedInstance].weixinAccount.realName];
            callback();
            
        } else {
            [HHMineNetwork getDefaultWechat:^(id error, HHWeixinAccountResponse *response) {
                if (error) {
                    NSLog(@"%@",error);
                    [self defaultWechat];
                } else {
                    [HHUserManager sharedInstance].weixinAccount = response.weixinAccount;
                    self.firModel = [HHMineNormalCellModel new];
                    self.firModel.imgName = @"icon_weixin";
                    self.firModel.text = [NSString stringWithFormat:@"%@ %@", response.weixinAccount.phone, response.weixinAccount.realName];
                    
                }
                callback();
            }];
        }
        
        
        
    }
    
    
    
}

- (void)defaultAli {
    self.firModel = [HHMineNormalCellModel new];
    self.firModel.imgName = @"zhifubao1";
    self.firModel.text = @"您尚未设置支付宝账户";
}

- (void)defaultWechat {
    self.firModel = [HHMineNormalCellModel new];
    self.firModel.imgName = @"icon_weixinweibangding";
    self.firModel.text = @"您尚未设置微信账户";
}


- (void)getProductList:(NSInteger)category
              callback:(void(^)())callback{
    
//    if ([HHUserManager sharedInstance].products) {
//        self.products = [HHUserManager sharedInstance].products;
//        callback();
//    } else {
    
        [HHMineNetwork getProductListByCategory:[NSNumber numberWithInteger:category] callback:^(id error, NSArray<HHProductOutline *> *products) {
            if (error) {
                NSLog(@"ali product error: %@",error);
            } else {
                [HHUserManager sharedInstance].products = products;
            }
            self.products = products;
            if (self.products.count) {
                [self initPurchaseView];
                [self.purchaseView setProduct:self.products[0]];
            }
            callback();
        }];
//    }
    
}

- (void)getCreditSummary:(void(^)())callback {
    
    [HHMineNetwork requestCreditSummary:^(id error, HHUserCreditSummary *summary) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            self.currentCredit = [NSString stringWithFormat:@"当前余额 : %@金币", [HHUtils insertComma:summary.remaining]];
            callback();
        }
    }];
    
}

- (void)initTableView {
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, H(self.view)) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHMallBindTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMallBindTableViewCell class])];
    [self.tableView registerClass:[HHMallProductTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMallProductTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:currentCredit];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:arrive_identifier];
}

- (void)initPurchaseView {
    
    CGFloat height = 70.0f;
    
    CGFloat navHeight = STATUSBAR_HEIGHT + H(self.navigationController.navigationBar);
    self.purchaseView = [[HHMallProductPurchaseView alloc] initWithFrame:CGRectMake(0, KHEIGHT - height - navHeight, KWIDTH, height)];
    [self.view addSubview:self.purchaseView];
    self.purchaseView.delegate = self;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3 + (self.products.count > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 60;
        
    } else if (indexPath.section == 1) {
        
        NSInteger lines = self.products.count / 3 + (self.products.count % 3 > 0);
        CGFloat height = lines * 100 + 20 * 2 + 20;
        return self.products.count > 0 ? height : 0;
        
//        return KHEIGHT - H(self.navigationController.navigationBar) - 60 - 60 - 80 - 70 - 12;
        
    } else if (indexPath.section == 2) {
        
        return 50;
        
    } else if (indexPath.section == 3) {
        
        return 60;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HHMallBindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMallBindTableViewCell class]) forIndexPath:indexPath];
        cell.model = self.firModel;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        HHMallProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMallProductTableViewCell class]) forIndexPath:indexPath];
        cell.products = self.products;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentCredit forIndexPath:indexPath];
        cell.textLabel.text = self.currentCredit;
        cell.textLabel.textColor = BLACK_51;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:arrive_identifier forIndexPath:indexPath];
        NSString *labelText = @"到账时间:\n正常最慢3天内到，请耐心等待，体谅一下客服妹子呦~";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        cell.textLabel.attributedText = attributedString;
        cell.textLabel.textColor = BLACK_51;
        cell.textLabel.font = Font(13);
        cell.textLabel.numberOfLines = 2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSetAccountCellCategory:)]) {
            [self.delegate clickSetAccountCellCategory:self.category];
        }
        
    }

}


- (void)selectProductItem:(HHProductOutline *)products {

    [self.purchaseView setProduct:products];
}

- (void)mallpurchaseViewPurchase:(HHProductOutline *)product {
    
    NSString *address = nil;
    if (self.category == alipy_category) {
        
        if (![HHUserManager sharedInstance].alipayAccount) {
            
            [HHHeadlineAwardHUD showMessage:@"请设置您的支付宝账户" hideTouch:YES animated:YES duration:2];
            return;
        }
        address = HHUserManager.sharedInstance.alipayAccount.mj_JSONString;
        
    } else if (self.category == wechat_category) {
        if (!HHUserManager.sharedInstance.weixinAccount) {
            [HHHeadlineAwardHUD showMessage:@"请设置您的微信账户" hideTouch:YES animated:YES duration:2];
            return;
        }
        address = HHUserManager.sharedInstance.weixinAccount.mj_JSONString;
    }
    
    [HHMineNetwork purchaseWithProductId:product.productOutlineId count:1 address:address message:@"" callState:0 voiceCode:@"" callback:^(id error, HHPurchaseResponse *response) {
        if (error) {
            [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
        } else {
            
            [HHHeadlineAwardHUD showMessage:response.msg animated:YES duration:2];
            
            [self getCreditSummary:^{
                [self.tableView reloadData];
            }];
        }
        
    }];
    
    
}










@end

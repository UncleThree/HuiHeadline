//
//  HHMallViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseViewController.h"

@protocol HHMallTableViewDelegate <NSObject>

- (void)clickSetAccountCellCategory:(NSInteger)category;

- (void)alertSuccessActionWithOrderId:(NSInteger)orderId;

@end

@interface HHMallViewController : HHBaseViewController

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, weak)id <HHMallTableViewDelegate> delegate;

@property (nonatomic, assign)ProductCategoryType category;

@end

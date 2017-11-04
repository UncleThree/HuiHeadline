//
//  HHOrderDetailViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMyOrderTableViewCell.h"

@interface HHOrderDetailViewController : UIViewController

@property (nonatomic, assign)NSInteger orderId;

@property (nonatomic, strong)HHOrderInfo *detailOrderInfo;

@end





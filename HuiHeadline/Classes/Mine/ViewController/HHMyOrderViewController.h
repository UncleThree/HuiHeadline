//
//  HHMyOrderViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseViewController.h"


@protocol  MyOrderDelegate <NSObject>

- (void)pushToOrderDetailVC:(HHOrderInfo *)orderInfo;


@end

@interface HHMyOrderViewController : HHBaseViewController

@property (nonatomic, assign)id<MyOrderDelegate> delegate;

@property (nonatomic, assign)NSInteger type;

@end

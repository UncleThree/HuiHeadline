//
//  HHMallBindAliViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHMallBindAliViewController : UIViewController

typedef void(^Callbck)(NSString *msg);

@property (nonatomic, copy)Callbck callback;

@property (nonatomic, strong)HHAlipayAccount *alipayAccount;

@property (nonatomic, assign)BOOL manager;

@end

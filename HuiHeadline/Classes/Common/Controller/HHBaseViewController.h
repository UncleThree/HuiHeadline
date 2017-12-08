//
//  HHBaseViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/15.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBaseViewController : UIViewController

///自定义导航栏
@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)id open_data;

- (void)loadBackView;

- (void)refresh;

@end

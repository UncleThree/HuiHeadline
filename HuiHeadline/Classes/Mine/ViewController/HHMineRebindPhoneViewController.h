//
//  HHMineBindPhoneViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindCallback)(NSString *phone);

@interface HHMineRebindPhoneViewController : UIViewController

@property (nonatomic)int countdown;

@property (nonatomic, copy)BindCallback callback;

@end

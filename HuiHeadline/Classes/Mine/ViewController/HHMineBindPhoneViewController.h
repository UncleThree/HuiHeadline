//
//  HHMineBindPhoneViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindPhoneCallback)(NSString *phone);


@interface HHMineBindPhoneViewController : UIViewController

@property (nonatomic)int countdown;

@property (nonatomic, copy)BindPhoneCallback callback;

@end

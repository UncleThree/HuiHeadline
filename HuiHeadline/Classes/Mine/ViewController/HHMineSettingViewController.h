//
//  HHMineSettingViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Callback)(void);


@interface HHMineSettingViewController : UIViewController

@property (nonatomic, copy)Callback callback;

@end

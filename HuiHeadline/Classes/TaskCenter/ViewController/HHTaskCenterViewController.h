//
//  HHTaskCenterViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HHTaskCenterViewController : UIViewController

+ (instancetype)defaultTaskCenterVC;

- (void)reloadHeader:(BOOL)forced;

- (void)reloadTableViewData;


@end
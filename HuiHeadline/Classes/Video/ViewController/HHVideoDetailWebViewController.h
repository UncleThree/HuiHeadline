//
//  HHVideoDetailWebViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHVideoDetailBottomView.h"

@interface HHVideoDetailWebViewController : UIViewController

@property(nonatomic,copy)NSString *URLString;

@property (nonatomic, strong)HHVideoDetailBottomView *buttomView;

@property (nonatomic)int totalTime;


@end

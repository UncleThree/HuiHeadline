//
//  HHMineChangePasswordViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangePasCallback)(NSString *msg);


@interface HHMineChangePasswordViewController : UIViewController

@property (nonatomic, copy)ChangePasCallback callback;

@end

//
//  HHMineUserNickViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NickCallback)(NSString *nickName);


@interface HHMineUserNickViewController : UIViewController

@property (nonatomic, copy)NSString *nickName;

@property (nonatomic, copy)NickCallback callback;

@end

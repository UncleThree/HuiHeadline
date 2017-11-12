//
//  HHRetrievePasswordViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHRetrievePasswordViewController : UIViewController

@property (nonatomic)int countdown;

@property (nonatomic, copy)void(^callback)(NSString *message);

@end

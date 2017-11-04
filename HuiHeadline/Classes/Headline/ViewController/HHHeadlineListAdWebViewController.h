//
//  HHHeadlineListAdWebViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHeadlineListAdWebViewController : UIViewController

@property (nonatomic, copy)void (^clickCallback)(void);

@property(nonatomic,copy)NSString *URLString;

@end

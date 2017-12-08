//
//  OpenActivityUtil.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityModel.h"

@interface OpenActivityUtil : NSObject

+ (void)pushViewControllerWithModel:(ActivityModel *)model
                           originVC:(UIViewController *)originVC
                         hideBottom:(BOOL)hide;

@end

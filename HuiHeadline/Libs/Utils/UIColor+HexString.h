//
//  UIColor+HexString.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end

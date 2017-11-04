//
//  CGQRCodeUtil.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGQRCodeUtil : NSObject

+ (CIImage *)createQRCodeImage:(NSString *)source;
+ (UIImage *)resizeQRCodeImage:(CIImage *)image withSize:(CGFloat)size;
+ (UIImage *)specialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;


@end

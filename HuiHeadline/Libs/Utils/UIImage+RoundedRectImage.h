//
//  UIImage+RoundedRectImage.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)

 + (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end

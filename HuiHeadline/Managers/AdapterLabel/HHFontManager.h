//
//  HHFontManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFontManager : NSObject

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end

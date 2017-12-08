//
//  HHFontManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHFontManager.h"

@implementation HHFontManager

+ (CGSize)sizeWithAttributeText:(NSAttributedString *)text maxSize:(CGSize)maxSize
{
    if (!text)
        return CGSizeMake(0, 0);
    return [text.string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[text attributesAtIndex:0 effectiveRange:NULL] context:nil].size;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

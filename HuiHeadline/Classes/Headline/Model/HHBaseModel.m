//
//  HHBaseModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/9.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHBaseModel.h"

@implementation HHBaseModel


- (CGFloat)getHeightWithText:(NSString *)text
                        font:(UIFont *)font {
    
    return  [HHFontManager sizeWithText:text font:font maxSize:CGSizeMake(KWIDTH - 2 * 12, MAXFLOAT)].height;
}


- (CGFloat)heightForCell {
    
    return 0;
}


@end

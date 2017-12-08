//
//  HHTaskCellModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskCellModel.h"

@implementation HHTaskCellModel

- (CGFloat )heightForModel {
    
    if (!self.show) {
        return 0;
    }
    if (_title && ![_title isEqualToString:@""]) {
        CGFloat width = KWIDTH - ( 12 + 12 + 12 + 20 + 65);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_title attributes:@{KEY_FONT:Font(15),KEY_COLOR:RGB(102, 102, 102)}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_title length])];
        [string addAttribute:KEY_COLOR value:HUIRED range:[_title rangeOfString:@"（每个视频下的白色区域）"]];
        CGFloat height = [HHFontManager sizeWithAttributeText:string maxSize:CGSizeMake(width, CGFLOAT_MAX)].height;
        return height + 50;
    }
    
    return 50;
    
}

@end

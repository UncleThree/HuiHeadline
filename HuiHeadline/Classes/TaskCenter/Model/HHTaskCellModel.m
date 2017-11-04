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
    return [HHFontManager sizeWithText:self.title font:Font(14) maxSize:CGSizeMake(KWIDTH / 2, CGFLOAT_MAX)].height + 40;
    
}

@end

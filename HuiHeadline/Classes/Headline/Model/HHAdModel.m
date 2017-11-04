//
//  HHAdModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/9.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHAdModel.h"

@implementation HHAdModel

- (HeadlineType)type_cell {
    
    return self.displayType;
    
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"subTitle":@"subtitle"
             };
}

- (CGFloat)heightForCell {
    
    CGFloat height = 0, padding = 0, imgHeight = 0, titleHeight = 0, subHeight = 0;
    
    if (self.type_cell == HeadlineTypeThreePic) {
        
        padding = 15 + 12 + 12 + 12;
        imgHeight = 80.0f;
        titleHeight = [self getHeightWithText:self.subTitle?:self.title font:kTitleFont];
        subHeight = [self getHeightWithText:@"广告" font:kSubtitleFont];
        
    } else if (self.type_cell == HeadlineTypeSmallPic) {
        
        padding = 12 + 12;
        imgHeight = 80.0f;
        
    } else {
        
        padding = 12 * 4;
        imgHeight = 200.0f;
        titleHeight = [self getHeightWithText:self.subTitle ?:self.title font:kTitleFont];
        subHeight = [self getHeightWithText:@"广告" font:kSubtitleFont];
        
    }
    height = padding + imgHeight + titleHeight + subHeight;
    
    return height;
}


@end

//
//  HHTopNewsModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTopNewsModel.h"

@implementation HHTopNewsModel

- (HeadlineType)type_cell {
    
    return _style;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"topNews_id" : @"id"
             };
}

- (NSString *)subTitle {
    
    return [[self.source stringByAppendingString:@"  "] stringByAppendingString:self.timeString];
}

//计算
- (NSString *)timeString {
    
    return [HHDateUtil timeFormatter:_mediaCreateTime];
    
}

- (NSArray<NSString *> *)pictureUrls {
    
    return [_pictures componentsSeparatedByString:@";"];
}

- (CGFloat)heightForCell {
    
    CGFloat height = 0, padding = 0, imgHeight = 0, titleHeight = 0, subHeight = 0;
    
    if (self.type_cell == HeadlineTypeThreePic) {
        
        padding = 15 + 12 + 12 + 12;
        imgHeight = 80.0f;
        titleHeight = [self getHeightWithText:self.title font:kTitleFont];
        subHeight = [self getHeightWithText:self.subTitle font:kSubtitleFont];
        
    } else if (self.type_cell == HeadlineTypeSmallPic) {
        
        padding = 12 + 12;
        imgHeight = 80.0f;
        
    } else {
        
        padding = 12 * 4;
        imgHeight = 200.0f;
        titleHeight = [self getHeightWithText:self.title font:kTitleFont];
        subHeight = [self getHeightWithText:self.subTitle font:kSubtitleFont];
        
    }
    height = padding + imgHeight + titleHeight + subHeight;
    
    return height;
}

@end

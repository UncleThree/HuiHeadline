//
//  HHHeadlineNewsModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHNewsModel.h"

@implementation HHNewsModel





- (HeadlineType)type_cell {
    
    if (self.bigpic) {
        return HeadlineTypeBigPic;
    } else if (self.miniimg_size == 3) {
        return HeadlineTypeThreePic;
    } else {
        return HeadlineTypeSmallPic;
    }
    
}

- (NSString *)subTitle {
    
    return [[self.source stringByAppendingString:@"  "] stringByAppendingString:self.timeString];
}

//计算
-(NSString *)timeString {
    
    return [HHDateUtil timeFormatter:_date];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"forUndefinedKey:%@",key);
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"title":@"topic"
             };
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

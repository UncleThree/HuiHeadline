//
//  HHUserMessageListResponse.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserMessageListResponse.h"

@implementation HHUserMessage

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"message_id":@"id"};
}


- (CGFloat)heightForMessage {
    
    CGFloat pad = 15;
    CGFloat littlePad = 10;
    CGFloat littleLabelW = 40;
    
    CGFloat height = 0;
    CGFloat titleHeight, timeHeight , imgHeight, contentHeight = 0;
    
    CGFloat allPad = 15 + 15 + (_content && ![_content isEqualToString:@""] ? 15 : 0) + (_picture && ![_picture isEqualToString:@""] ? 15 : 0) + 10;
    titleHeight = [HHFontManager sizeWithText:_title font:kTitleFont maxSize:CGSizeMake(KWIDTH - pad * 2 - littlePad * 2 - 5 - littleLabelW, CGFLOAT_MAX)].height;
    timeHeight = 20;
    imgHeight = _picture && ![_picture isEqualToString:@""] ? 450 / 936.0 * (KWIDTH - pad * 2 - littlePad * 2) : 0;
    
    if (_content && ![_content isEqualToString:@""]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_content attributes:@{KEY_FONT:K_Font(16), KEY_COLOR:BLACK_153}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_content length])];
        CGSize size = CGSizeMake(KWIDTH - pad * 2 - littlePad * 2, CGFLOAT_MAX);
        contentHeight = [HHFontManager sizeWithAttributeText:string maxSize:size].height + 1;
    } else {
        contentHeight = 0;
    }
    
    height = titleHeight + timeHeight + imgHeight + contentHeight + allPad + 40;
    return height;
    
}

@end

@implementation HHUserMessageListResponse

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"userMessageList":@"HHUserMessage"};
}

@end


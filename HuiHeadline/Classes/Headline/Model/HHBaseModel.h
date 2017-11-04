//
//  HHBaseModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/9.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    HeadlineTypeSmallPic = 0, //三张图
    HeadlineTypeThreePic = 1,  //左边图
    HeadlineTypeBigPic   = 2 //大图 广告
    
} HeadlineType;

@interface HHBaseModel : NSObject


//cell类型
@property (nonatomic, assign)HeadlineType type_cell;

@property (nonatomic, assign)BOOL hasClicked;


- (CGFloat)heightForCell;

- (CGFloat)getHeightWithText:(NSString *)text
                        font:(UIFont *)font;


@end

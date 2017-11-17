//
//  HHHeadlineNewsBaseTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNewsBaseTableViewCell.h"

@implementation HHHeadlineNewsBaseTableViewCell

- (void)setModel:(HHBaseModel *)model {
    
    if ([model isKindOfClass:[HHNewsModel class]]) {
        [self setNewsModel:(HHNewsModel *)model];
    } else if ([model isKindOfClass:[HHAdModel class]]) {
        [self setAdModel:(HHAdModel *)model];
    } else if ([model isKindOfClass:[HHTopNewsModel class]]) {
        
        [self setTopModel:(HHTopNewsModel *)model];
    }
    
}


@end

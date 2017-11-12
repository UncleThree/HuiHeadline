
//
//  BMTodayHeadlinesDragCell.m
//  TodayHeadlinesDrag
//
//  Created by __liangdahong on 2017/7/23.
//  Copyright © 2017年 http://idhong.com. All rights reserved.
//

#import "BMTodayHeadlinesDragCell.h"

@interface BMTodayHeadlinesDragCell ()



@end

@implementation BMTodayHeadlinesDragCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textColor = RGB(58, 58, 58);
    self.titleLabel.font = Font(16);
       
    self.mybackgroundView.layer.cornerRadius = 5.0;
    self.mybackgroundView.layer.borderColor = RGB(202, 202, 202).CGColor;
    self.mybackgroundView.layer.borderWidth = 1;
    
    self.removeButton.backgroundColor = [UIColor whiteColor];
    self.removeButton.image = [UIImage imageNamed:@"关闭"];
    
   
}



@end

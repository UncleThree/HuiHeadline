//
//  HHHeadlineChannelListHeaderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/15.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineChannelListHeaderView.h"

@interface HHHeadlineChannelListHeaderView ()




@end


@implementation HHHeadlineChannelListHeaderView




- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.myChannelLabel.textColor = BLACK_51;
    self.myChannelLabel.font = Font(19);
    self.myChannelLabel.text = @"我的频道";
    
    
    self.dragLabel.textColor = BLACK_153;
    self.dragLabel.font = Font(13);
    self.dragLabel.text = @"长按拖动排序";
    
    self.editButton.layer.cornerRadius = 5.0f;
    self.editButton.clipsToBounds = YES;
    self.editButton.layer.borderWidth = 0.3f;
    self.editButton.layer.borderColor = HUIRED.CGColor
    ;
    kButton_setAttr_normalState(self.editButton, @"编辑", HUIRED, Font(15));
    
    
    
}



@end

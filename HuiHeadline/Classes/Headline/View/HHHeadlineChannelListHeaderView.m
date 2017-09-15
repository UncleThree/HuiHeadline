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
    
    self.editButton.layer.cornerRadius = 5.0f;
    self.editButton.clipsToBounds = YES;
    self.editButton.layer.borderWidth = 0.3f;
    self.editButton.layer.borderColor = [UIColor redColor].CGColor
    ;
    
}



@end

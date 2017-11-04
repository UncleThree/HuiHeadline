//
//  HHTextFieldAndLineView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTextFieldAndLineView.h"

@interface  HHTextFieldAndLineView ()



@end

@implementation HHTextFieldAndLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}

- (void)initUI:(CGRect)frame {
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 1.0f)];
    [self addSubview:self.textField];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.textField), W(self.textField), 0.5)];
    self.line.backgroundColor = [UIColor grayColor];
    [self addSubview:self.line];
}


@end

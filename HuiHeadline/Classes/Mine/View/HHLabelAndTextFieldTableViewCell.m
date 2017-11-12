//
//  HHLabelAndTextFieldTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHLabelAndTextFieldTableViewCell.h"

@implementation HHLabelAndTextFieldModel

@end



@interface HHLabelAndTextFieldTableViewCell ()

@property (nonatomic, strong)UILabel *label;



@end

@implementation HHLabelAndTextFieldTableViewCell

#define cell_height 50


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    UIFont *font = Font(16);
    CGFloat labelWidth = [HHFontManager sizeWithText:@"啦啦啦啦：" font:font maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, labelWidth + 20, cell_height)];
    self.label.font = font;
    self.label.textColor = BLACK_153;
    [self.contentView addSubview:self.label];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(MaxX(self.label) , 0, KWIDTH - 40 - W(self.label), cell_height)];
    self.textField.font = Font(15);
    [self.contentView addSubview:self.textField];
    
}

- (void)setModel:(HHLabelAndTextFieldModel *)model {
    
    _model = model;
    
    
    if (!model.tfText || [model.tfText isEqualToString:@""]) {
        
        self.label.text = model.labelText;
        self.textField.placeholder = model.placeholder;
        
    } else {
        self.label.text = model.labelText;
        self.textField.text = model.tfText;

    }
    self.textField.enabled = model.tfEnabled;
    
    self.textField.textColor = model.tfEnabled ? BLACK_51 : BLACK_153;
    
}


@end

//
//  HHLabelAndTextFieldTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLabelAndTextFieldModel : NSObject



@property (nonatomic, strong)NSString *labelText;

@property (nonatomic, strong)NSString *placeholder;

@property (nonatomic, strong)NSString *tfText;

@property (nonatomic, assign)BOOL tfEnabled;



@end

@interface HHLabelAndTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)HHLabelAndTextFieldModel *model;

@end

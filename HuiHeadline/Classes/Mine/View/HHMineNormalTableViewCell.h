//
//  HHMineNormalTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMineNormalCellModel.h"

@interface HHMineNormalTableViewCell : UITableViewCell

@property (nonatomic, strong)HHMineNormalCellModel *model;

@end


///新消息 新版本的view
@interface HHMainNormalRedBackAndLabelView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text;

@end

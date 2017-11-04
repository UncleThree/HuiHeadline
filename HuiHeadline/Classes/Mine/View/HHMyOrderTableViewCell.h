//
//  HHMyOrderTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHOrderResponse.h"

@interface HHMyOrderTableViewCellModel : NSObject



@end

@interface HHMyOrderTableViewCell : UITableViewCell

@property (nonatomic, strong)HHOrderInfo *orderInfo;

@end

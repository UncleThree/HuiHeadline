//
//  HHHeadlineNewsBaseTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseModel.h"
#import "HHNewsModel.h"
#import "HHAdModel.h"
#import "HHTopNewsModel.h"

@interface HHHeadlineNewsBaseTableViewCell : UITableViewCell

@property (nonatomic, strong)HHBaseModel *model;

@property (nonatomic, strong)HHNewsModel *newsModel;

@property (nonatomic, strong)HHAdModel *adModel;

@property (nonatomic, strong)HHTopNewsModel *topModel;

@end

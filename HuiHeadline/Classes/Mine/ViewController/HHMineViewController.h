//
//  HHMainViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMineNormalCellModel.h"
#import "HHMineHeaderView.h"

@interface HHMineViewController : UIViewController

@property (nonatomic, strong)NSMutableArray<HHMineNormalCellModel *> *models;

@property (nonatomic, strong)NSMutableArray<HHMineNormalCellModel *> *settingModels;

@property (nonatomic, strong)HHMineHeaderView *headerView;

+ (instancetype)defaultMineVC;

- (void)realoadHeaderData:(BOOL)requst;



@end

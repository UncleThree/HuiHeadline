//
//   HHHeadlineListViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHNewsModel.h"
#import "HHAdModel.h"
#import "HHTopNewsModel.h"

@class HHBaseModel;

static NSString *normalCell = @"HHHeadlineNewsThreePicTableViewCell";
static NSString *leftRightCell = @"HHHeadlineNewsLeftRightTableViewCell";
static NSString *bigImgCell = @"HHHeadlineNewsBigImgTableViewCell";

@interface  HHHeadlineListViewController : UIViewController

//头条 社会 。。。
@property (nonatomic, copy)NSString *type;

//总的列表
@property (nonatomic, strong)NSMutableArray<HHBaseModel *> *data;
//新闻列表
@property (nonatomic, strong)NSMutableArray<HHNewsModel *> *newsData;
//置顶新闻列表
@property (nonatomic, strong)NSMutableArray<HHTopNewsModel *> *topData;
//广告列表

//用manager 管理这个数组 显示之后移除
@property (nonatomic, strong)NSMutableArray<HHAdModel *> *adData;

//广告 待处理


@property (nonatomic, strong)MJRefreshHeader *header;
@property (nonatomic, strong)MJRefreshFooter *footer;

- (void)showNav:(BOOL)show;


@end

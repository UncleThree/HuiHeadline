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
#import "HHBaseViewController.h"

@class HHBaseModel;

static NSString *normalCell = @"HHHeadlineNewsThreePicTableViewCell";
static NSString *leftRightCell = @"HHHeadlineNewsLeftRightTableViewCell";
static NSString *bigImgCell = @"HHHeadlineNewsBigImgTableViewCell";

@interface  HHHeadlineListViewController : HHBaseViewController

@property (nonatomic, strong)UITableView *tableView;
//头条 社会 。。。
@property (nonatomic, copy)NSString *type;

//新闻列表
@property (nonatomic, strong)NSMutableArray<HHNewsModel *> *newsData;
//置顶新闻列表
@property (nonatomic, strong)NSMutableArray<HHTopNewsModel *> *topData;
//广告列表

//用manager 管理这个数组 显示之后移除
@property (nonatomic, strong)NSMutableArray<HHAdModel *> *adData;

@property (nonatomic, strong)NSMutableArray<HHBaseModel *> *data;


@property (nonatomic, strong)MJRefreshHeader *header;
@property (nonatomic, strong)MJRefreshFooter *footer;

- (void)showNav:(BOOL)show;

- (void)requestAdsWithRowTag:(NSInteger)tag;

@property (nonatomic, strong)NSMutableDictionary<NSString *, NSNumber *> *adMap;
///处理曝光  超过5分钟未曝光或者浏览广告数达到五个
- (void)handlerAdExposure:(HHAdModel *)adModel;



@end

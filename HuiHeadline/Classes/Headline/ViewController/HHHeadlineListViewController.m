//
//   HHHeadlineListViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListViewController.h"
#import "HHHeadlineNewsLeftRightTableViewCell.h"
#import "HHHeadlineNewsThreePicTableViewCell.h"
#import "HHHeadlineNewsBigImgTableViewCell.h"
#import "HHHeadlineListViewController+tableView.h"

@interface  HHHeadlineListViewController ()


@property (nonatomic, strong)UIImageView *backgroundView;

@property (nonatomic, strong)UITableView *tableView;

@end



@implementation  HHHeadlineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self requestData];
   
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showNav:YES];
}


- (void)requestData {
    
    [self requstNews:^{
    
        [self requestTopNews:^{
            [self requestAds:^{
                
                [self reloadData];
            }];
            
        }];
        
    }];
    
}



- (void)requstNews:(void(^)())handler {
    
    [HHHeadlineNetwork requestForNewsWithType:self.type isFirst:YES refresh:NO handler:^(NSError *error, id result) {
        
        if (result && [result isKindOfClass:[NSArray class]]) {
            NSLog(@"------新闻数据------%zd",[(NSArray *)result count]);
//            for (id model in result) {
//                NSLog(@"%@", [model mj_keyValues]);
//            }
            [self.newsData removeAllObjects];
            [self.newsData addObjectsFromArray:result];
            

        }
        handler();
    }];
    
}

- (void)requestTopNews:(void(^)())handler {
    if (![self.type isEqualToString:@"头条"]) {
        handler();
        return;
    }
    [HHHeadlineNetwork requestForTopNews:^(NSError *error, id result) {
        if (error) {
            Log(error);
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {
                // data待处理
                NSLog(@"------置顶新闻数据------%zd",[(NSArray *)result count]);
//                for (id model in result) {
//                    NSLog(@"%@", [model mj_keyValues]);
//                }
                [self.topData removeAllObjects];
                [self.topData addObjectsFromArray:result];
            }
        }
        handler();
    }];
}

- (void)requestAds:(void(^)())handler {
    [HHHeadlineNetwork requestForAdList:^(NSError *error, id result) {
        if (error) {
            Log(error);
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {
                NSLog(@"------广告数据------%zd",[(NSArray *)result count]);
//                for (id model in result) {
//                    NSLog(@"%@", [model mj_keyValues]);
//                }
                [self.adData removeAllObjects];
                [self.adData addObjectsFromArray:result];
                
            }
            
        }
        handler();
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}


- (void)showNav:(BOOL)show {
    
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            view.hidden = !show;
        }
    }
}


// 将广告插入数组中 第一个在下标1 然后每隔五个插入一个
- (void)insertAds {
    
    for (int i = 0; i < self.adData.count; i++) {
        int temp = -1;
        int count = 0;
        for (int j = 0 ; j < self.data.count; j++) {
            if ((j - 1) % 6 == 0 ) {
                count++;
                if (count == i) {
                    temp = j;
                    break;
                }
            }
        }
        if (temp != -1) { //不是break出来的为-1 过滤掉
            [self.data insertObject:self.adData[i] atIndex:temp];
        }
    }
    
}



- (void)reloadData {
    
    [self.data removeAllObjects];
    //插入新闻
    [self.data addObjectsFromArray:self.newsData.copy];
    if (self.adData.count && self.data.count) {
        //插入广告
        [self insertAds];
    }
    //插入置顶新闻
    [self.data insertObjects:self.topData.copy atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.topData.count)]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (NSMutableArray<HHBaseModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
    
}

- (NSMutableArray<HHNewsModel *> *)newsData {
    
    if (!_newsData) {
        _newsData = [NSMutableArray array];
    }
    return _newsData;
}

- (NSMutableArray<HHTopNewsModel *> *)topData {
    if (!_topData) {
        _topData = [NSMutableArray array];
    }
    return _topData;
}

- (NSMutableArray<HHAdModel *> *)adData {
    if (!_adData) {
        _adData = [NSMutableArray array];
    }
    return _adData;
}


- (void)initTableView {
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsThreePicTableViewCell class]) bundle:nil] forCellReuseIdentifier:normalCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsLeftRightTableViewCell class]) bundle:nil] forCellReuseIdentifier:leftRightCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsBigImgTableViewCell class]) bundle:nil] forCellReuseIdentifier:bigImgCell];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefresh:)];
    self.header = self.tableView.mj_header;
    [(MJRefreshStateHeader *)self.header lastUpdatedTimeLabel].hidden = YES;
    [(MJRefreshStateHeader *)self.header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [(MJRefreshStateHeader *)self.header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefresh:)];
    self.footer = self.tableView.mj_footer;
}

#pragma mark MJRefresh

///刷新 刷新topNews
- (void)mjRefresh:(id)sender {
    
    BOOL refresh = [sender isKindOfClass:[MJRefreshNormalHeader class]];
    
    [HHHeadlineNetwork requestForNewsWithType:self.type isFirst:NO refresh:refresh handler:^(NSError *error, id result) {
        if (error) {
            Log(error);
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {
                if (refresh) {
                    //刷新 先清空
                    [self.newsData removeAllObjects];
                    [self.newsData addObjectsFromArray:result];
                    
                    [self requestTopNews:^{
                        [self requestAds:^{
                            [self reloadData];
                            [self.header endRefreshing];
                            [self.footer endRefreshing];
                        }];
                    }];
                } else {
                    [self.newsData addObjectsFromArray:result];
                    [self reloadData];
                    [self.header endRefreshing];
                    [self.footer endRefreshing];
                }
                
                
                
            }
            
        }
    }];
    
}



@end

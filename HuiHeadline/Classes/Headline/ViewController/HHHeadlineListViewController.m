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
#import "HHHeadlineNavController.h"
#import "HHDeviceUtils.h"
#import "Reachability.h"
#import "HHAdAwardManager.h"

@interface  HHHeadlineListViewController ()


@property (nonatomic, strong)UIImageView *backgroundView;



@property (nonatomic, strong)NSCache *cache;

@end



@implementation  HHHeadlineListViewController

{
    BOOL exposuring;
}

- (void)viewDidLoad {
   
    [self initTableView];
    
    [super viewDidLoad];
    
    [self requestData];
   

}






- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self showNav:YES];
    
    if ([[self.navigationController class] isEqual:[HHHeadlineNavController class]]) {
        
        [(HHHeadlineNavController *)self.navigationController setAppear:YES];
        [(HHHeadlineNavController *)self.navigationController checkHourAward];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    if ([[self.navigationController class] isEqual:[HHHeadlineNavController class]]) {
        [(HHHeadlineNavController *)self.navigationController setAppear:NO];
    }
}

- (void)requestData {
    
    [self requstNews:YES];
    
    [self requestTopNews];
    

}

- (void)refresh {
    
    [super refresh];
    
    [self requestData];
    
}

- (void)requstNews:(BOOL)refresh {
    
    [HHHeadlineNetwork requestForNewsWithType:self.type isFirst:NO refresh:refresh handler:^(NSError *error, id result) {
        
        if (result && [result isKindOfClass:[NSArray class]]) {
            NSLog(@"------新闻数据------%zd",[(NSArray *)result count]);
            if (refresh) {
                [self.newsData removeAllObjects];
            }
            [self.newsData addObjectsFromArray:result];
            
        }
        
        [self reloadData];
        
        
        
        
    }];
    
}

- (void)requestTopNews {
    if (![self.type isEqualToString:@"头条"] || G.$.bs) {
        return;
    }
    [HHHeadlineNetwork requestForTopNews:^(NSError *error, id result) {
        if (error) {
            Log(error);
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {
                
                NSLog(@"------置顶新闻数据------%zd",[(NSArray *)result count]);
                [self.topData removeAllObjects];
                [self.topData addObjectsFromArray:result];
                [self.tableView reloadData];
            }
        }
       
    }];
}

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}


- (void)requestAdsWithRowTag:(NSInteger)tag {
    
    ///如果存在 直接刷新
    if (self.adData.count && self.adData.count - 1 >= (tag - 1) / 6 ) {
        [self.tableView reloadData];
        return;
    }
    ///正在缓存 不需要加载
    if ([self.cache objectForKey:@(tag)]) {
        return;
    }
    ///加载新的广告
    [self.cache setObject:@(1) forKey:@(tag)];
    NSLog(@"广告请求");
    [HHHeadlineNetwork requestForAdList:^(NSError *error, id result) {
        [self.cache setObject:@(0) forKey:@(tag)];
        if (error) {
            
            Log(error);
            
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {

                [self.adData addObjectsFromArray:result];
                if (self.adData.count) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }
        }

    }];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}


- (void)showNav:(BOOL)show {
    
    [[(HHHeadlineNavController *)self.navigationController timeLabel] setHidden:!show];
    [[(HHHeadlineNavController *)self.navigationController alarmImgv] setHidden:!show];
    [[(HHHeadlineNavController *)self.navigationController titleImgV] setHidden:!show];
}


// 将广告插入数组中 第一个在下标1 然后每隔五个插入一个
- (void)insertAds {

    for (int i = 0; i < self.data.count; i++) {
        if ((i - 1) % 6 == 0 ) {
            HHAdModel *model = (HHAdModel *)[NSNull null];
            [self.data insertObject:model atIndex:i];
            [self requestAdsWithRowTag:i];
        }
    }
    
}


- (void)exposureMap:(HHAdModel *)adModel {
    if ([self.adMap.allKeys containsObject:adModel.type]) {
        
        NSInteger integer = [[self.adMap objectForKey:adModel.type] integerValue];
        [self.adMap setObject:@(++integer) forKey:adModel.type];
        
    } else {
        [self.adMap setObject:@(1) forKey:adModel.type];
    }
    NSLog(@"%@",self.adMap);
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval place = time - HHUserManager.sharedInstance.lastSychAdTime ;
    if (((HHUserManager.sharedInstance.lastSychAdTime && place > 5 * 60) ||  [self getAllCount] >= 5) && !exposuring) {
        
        exposuring = YES;
        [HHHeadlineNetwork sychListAdExposureWithMap:self.adMap callback:^(id error, HHSychAdExposureResponse *response) {
            
            if (error) {
                NSLog(@"%@",error);
            } else if (response.statusCode != 200) {
                NSLog(@"%@",response.msg);
            } else {
                NSLog(@"曝光成功");
                
                [self showAdAward:response];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exposuring = NO;
            });
        }];
        HHUserManager.sharedInstance.lastSychAdTime = [[NSDate date] timeIntervalSince1970];
        [self.adMap removeAllObjects];
    }
}

- (void)handlerAdExposure:(HHAdModel *)adModel {

    
    [self exposureMap:adModel];
    
    
    if (!adModel.listExporsed) {
        
        [HHHeadlineNetwork sychExposureList:adModel.exposureReportList];
        adModel.listExporsed = YES;
    }
    
}

- (void)showAdAward:(HHSychAdExposureResponse *)response
{
    
    if (response.encourageInfoMap && response.encourageInfoMap.allKeys.count) {
        
        [[HHAdAwardManager sharedInstance] disposeEncourageInfoMap:response.encourageInfoMap];
    } else {
        
        NSLog(@"%@",response.encourageInfoMap);
    }
    
}




- (NSInteger)getAllCount {
    
    NSInteger count = 0;
    for (NSString *key in self.adMap) {
        count += [self.adMap[key] integerValue];
    }
    return count;
    
}

- (void)reloadData {
    
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:self.newsData];
    [self insertAds];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    });
    
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

- (NSMutableArray<HHBaseModel *> *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableDictionary *)adMap {
    if (!_adMap) {
        _adMap = [NSMutableDictionary dictionary];
    }
    return _adMap;
}



- (void)initTableView {
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsThreePicTableViewCell class]) bundle:nil] forCellReuseIdentifier:normalCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsLeftRightTableViewCell class]) bundle:nil] forCellReuseIdentifier:leftRightCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HHHeadlineNewsBigImgTableViewCell class]) bundle:nil] forCellReuseIdentifier:bigImgCell];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefresh:)];
    self.header = self.tableView.mj_header;
    [(MJRefreshStateHeader *)self.header lastUpdatedTimeLabel].hidden = YES;
    [(MJRefreshStateHeader *)self.header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [(MJRefreshStateHeader *)self.header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [(MJRefreshStateHeader *)self.header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefresh:)];
    self.footer = self.tableView.mj_footer;
}

#pragma mark MJRefresh

///刷新 刷新topNews
- (void)mjRefresh:(id)sender {
    
    BOOL refresh = [sender isKindOfClass:[MJRefreshNormalHeader class]];
    
    [self requstNews:refresh];
    
    if (refresh) {
        [self.cache removeAllObjects];
        [self.adData removeAllObjects];
        [self requestTopNews];
        
    }
    
    
}



@end

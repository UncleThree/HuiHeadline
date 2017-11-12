//
//  HHIncomeDetailViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHIncomeDetailViewController.h"
#import "HHIncomeDetailTableViewCell.h"

@interface HHIncomeDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHIncomeDetail *> *models;

@property (nonatomic, strong)NSMutableArray *keys;

@property (nonatomic, strong)NSDictionary <NSString *,NSMutableArray<HHIncomeDetail *> *> *separateDict;

@property (nonatomic, assign)long lastTime;

@property (nonatomic, copy)NSString *footerString;

@end

#define NOMORE @"(*￣ω￣) 没有更多了"

@implementation HHIncomeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initTableView];
    
   
    [self requestIncomeDetailWithNew:YES callback:^{
        [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
        [self.tableView reloadData];
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
    }];
    
}

- (void)requestIncomeDetailWithNew:(BOOL)clear
                          callback:(void(^)())callback {
    if (clear) {
        self.footerString = nil;
        [self initFooter];
    }
    
    [HHMineNetwork requestIncome:(IncomeDetailCategoryAll) time:clear ? 0 : self.lastTime callback:^(id error, HHIncomDetailResponse *response) {
        if (error) {
            NSLog(@"income detail error : %@",error);
        } else {

            if (clear) {
                [self.models removeAllObjects];
            }
            if (!response.creditDetailList.count) {
                
                self.footerString = NOMORE;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer = nil;
                
            } else {
                
                NSInteger lastTime = [response.creditDetailList lastObject].createTime;
                self.lastTime = lastTime;
                [self.models addObjectsFromArray:response.creditDetailList];
                self.separateDict = [self separateSF:self.models];
            }
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        callback();
        
    }];
    
}

- (NSMutableArray<HHIncomeDetail *> *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)keys {
    if (!_keys) {
        _keys = [NSMutableArray array];
    }
    return _keys;
}

- (NSDictionary *)separateSF:(NSArray *)models {
    
//    NSArray *descs = @[[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO]];
//    NSArray *sortedModels = [models sortedArrayUsingDescriptors:descs];
    NSArray *sortedModels = models;
    NSMutableDictionary *separateDict = [NSMutableDictionary dictionary];
    NSString *day = nil;
    [self.keys removeAllObjects];
    for (HHIncomeDetail *income in sortedModels) {
        
        NSString *model_day  =  income.timeArray[0];
        if (![model_day isEqualToString:day]) {
            
            [self.keys addObject:model_day];
            day = model_day;
            [separateDict setObject:[NSMutableArray array] forKey:model_day];
            [separateDict[model_day] addObject:income];
            
        } else {
            [[separateDict objectForKey:model_day] addObject:income];
        }
    }
    return separateDict.copy;
}

- (void)initNavigation {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 收益明细"];
    [self.view addSubview:self.navigationView];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.navigationView), KWIDTH, KHEIGHT - MaxY(self.navigationView)) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 0.01f)];
    [self.tableView registerClass:[HHIncomeDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHIncomeDetailTableViewCell class])];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self initFooter];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initFooter {
    MJRefreshBackNormalFooter *footer  = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = footer;
}

- (void)refresh {
    
    [self requestIncomeDetailWithNew:YES callback:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMore {
    
    [self requestIncomeDetailWithNew:NO  callback:^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = self.keys[section];
    return [self.separateDict objectForKey:key].count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == self.keys.count - 1 && self.footerString) {
        
        return 40;
        
    } else {
        
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 30)];
    label.textColor = BLACK_153;
    label.text = self.footerString;
    label.textAlignment = 1;
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 40)];
    label.textColor = BLACK_153;
    NSString *key = self.keys[section];
    HHIncomeDetail *model = self.separateDict[key][0];
    label.text = model.timeArray[0];
    label.textAlignment = 2;
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHIncomeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHIncomeDetailTableViewCell class]) forIndexPath:indexPath];
    NSString *key = self.keys[indexPath.section];
    cell.model = self.separateDict[key][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

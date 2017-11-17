//
//  HHMineInvitedCreditViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineInvitedCreditViewController.h"
#import "HHInvitedConstributionSummaryResponse.h"
#import "HHInvitedCreditTableViewCell.h"

@interface HHMineInvitedCreditViewController () <UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHInvitedConstributionSummary *> *data;

@end

@implementation HHMineInvitedCreditViewController

{
    BOOL noMore;
    int count;
}


- (void)viewDidLoad {
    
    [self initNavigation];
    [self initTableView];
    
    [super viewDidLoad];
}




- (NSMutableArray<HHInvitedConstributionSummary *> *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    [self requestInviteConstributionWithFresh:YES more:NO];
}


- (void)requestInviteConstributionWithFresh:(BOOL)fresh
                                       more:(BOOL)more{
    if (fresh) {
        count = 0;
        noMore = NO;
        [self initFooter];
        [self.data removeAllObjects];
    }
    if (more) {
        count++;
    }
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    [HHMineNetwork requestInviteConstribution:count callback:^(id error, NSArray<HHInvitedConstributionSummary *> *constributions) {
        if (error) {
            Log(error);
        } else {
            if (constributions.count) {
                [self.data addObjectsFromArray:constributions];
            } else {
                noMore = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer = nil;
                if (fresh) {
                    [self addNoLabel];
                    [self.tableView removeFromSuperview];
                }
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];
            [HHHeadlineAwardHUD hideHUDAnimated:YES];
        });
        
    }];
}


- (void)addNoLabel {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"暂无收益";
    label.textColor = BLACK_153;
    label.textAlignment = 1;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.centerX.centerY.equalTo(self.view);
    }];
    
}

- (void)initNavigation {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 徒弟提供的收益"];
    [self.view addSubview:self.navigationView];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.navigationView), KWIDTH, KHEIGHT - MaxY(self.navigationView)) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[HHInvitedCreditTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHInvitedCreditTableViewCell class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initHeader];
    [self initFooter];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 12)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
}

- (void)initHeader {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)initFooter {
    MJRefreshBackNormalFooter *footer  = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = footer;
}

- (void)refresh {
    
    [super refresh];
    [self requestInviteConstributionWithFresh:YES more:NO];
}

- (void)loadMore {
    
    [self requestInviteConstributionWithFresh:NO more:YES];
    
}

#pragma mark UITableViewDataSource

kRemoveCellSeparator

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    return noMore ? 30 : 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHInvitedCreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHInvitedCreditTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 30)];
    label.textColor = BLACK_153;
    label.text = @"(*￣ω￣) 没有更多了";
    label.textAlignment = 1;
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    return view;
    
}


@end

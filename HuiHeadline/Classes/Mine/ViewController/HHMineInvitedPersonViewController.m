//
//  HHMineInvitedCreditViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineInvitedPersonViewController.h"
#import "HHInvitedSummaryResponse.h"
#import "HHInvitedCreditTableViewCell.h"

@interface HHMineInvitedPersonViewController () <UITableViewDataSource, UITableViewDelegate>




@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHInvitedSummary *> *data;

@end

@implementation HHMineInvitedPersonViewController

{
    BOOL noMore;
    int count;
}


- (void)viewDidLoad {
    
    
    
    [self initNavigation];
    
    [self initTableView];
    
    [super viewDidLoad];
    
}



- (NSMutableArray<HHInvitedSummary *> *)data {
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
        [self.data removeAllObjects];
    }
    if (more) {
        count++;
    }
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    [HHMineNetwork requestInviteSummary:count callback:^(id error, NSArray<HHInvitedSummary *> *constributions) {
        if (error) {
            Log(error);
        } else {
            if (constributions.count) {
                
                [self.data addObjectsFromArray:constributions];
               
                if (fresh && constributions.count == self.personCount) {
                    self.tableView.bounces = NO;
                } else {
                    self.tableView.bounces = YES;
                    
                }
            }  else {
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
    label.text = @"暂无邀请徒弟";
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
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 成功邀请的徒弟"];
    [self.view addSubview:self.navigationView];
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initTableView {
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.navigationView), KWIDTH, KHEIGHT - MaxY(self.navigationView)) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 12;
    [self.tableView registerClass:[HHInvitedCreditTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHInvitedCreditTableViewCell class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 12)];
//    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    [self initHeader];
    [self initFooter];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 12;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return noMore && self.tableView.contentOffset.y > H(self.tableView) ? 30 : 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHInvitedCreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHInvitedCreditTableViewCell class]) forIndexPath:indexPath];
    cell.summaryModel = self.data[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 30)];
    label.textColor = BLACK_153;
//    label.text = @"(*￣ω￣) 没有更多了";
    label.textAlignment = 1;
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    return view;
    
}


@end


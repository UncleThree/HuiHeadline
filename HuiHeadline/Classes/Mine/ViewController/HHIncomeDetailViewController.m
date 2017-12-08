//
//  HHIncomeDetailViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHIncomeDetailViewController.h"
#import "HHIncomeDetailTableViewCell.h"
#import "HHMineIncomeDetailClassifyView.h"

@interface HHIncomeDetailViewController () <UITableViewDataSource, UITableViewDelegate, ClassifyDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHIncomeDetail *> *models;

@property (nonatomic, strong)NSMutableArray *keys;

@property (nonatomic, strong)NSDictionary <NSString *,NSMutableArray<HHIncomeDetail *> *> *separateDict;

@property (nonatomic, assign)long lastTime;

@property (nonatomic, copy)NSString *footerString;

@property (nonatomic, strong)HHMineIncomeDetailClassifyView *classifyView;

@property (nonatomic, strong)UIView *darkView;

@property (nonatomic, strong)UIView *noIncomeView;

@property (nonatomic, assign)IncomeDetailCategory category;

@end

#define NOMORE @"(*￣ω￣) 没有更多了"

@implementation HHIncomeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    [self requestIncomeDetailWithNew:YES category:(self.category) callback:^{
        
        [self.tableView reloadData];
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
    }];
}


- (void)viewDidLoad {
    
    [self initNavigation];
    [self initTableView];
    
    [super viewDidLoad];
    
    
}

- (void)requestIncomeDetailWithNew:(BOOL)clear
                          category:(IncomeDetailCategory)category
                          callback:(void(^)())callback {
    if (clear) {
        self.footerString = nil;
        [self initFooter];
    }
    
    [HHMineNetwork requestIncome:(category) time:clear ? 0 : self.lastTime callback:^(id error, HHIncomDetailResponse *response) {
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
                if (clear) {
                    [self loadBackView];
                }
            } else {
                
                NSInteger lastTime = [response.creditDetailList lastObject].createTime;
                self.lastTime = lastTime;
                [self.models addObjectsFromArray:response.creditDetailList];
                
            }
            self.separateDict = [self separateSF:self.models];
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (self.models.count) {
            self.noIncomeView.hidden = YES;
        } else {
            self.noIncomeView.hidden = NO;
        }
        if (callback) {
            callback();
        }
        
        
    }];
    
}

- (void)loadBackView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.noIncomeView = backView;
    backView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    [self.view addSubview:backView];
    [self.view bringSubviewToFront:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake( H(self.navigationView) , 0, 0, 0));
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"notice_robot"];
    imgV.image = image;
    [backView addSubview:imgV];
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWIDTH / 3);
        make.height.mas_equalTo(image.size.height / image.size.width * KWIDTH / 3);
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).with.offset(-20);
    }];
    
    UILabel *noLinkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noLinkLabel.textColor = BLACK_153;
    noLinkLabel.textAlignment = 1;
    noLinkLabel.text = @"暂无收益明细";
    noLinkLabel.font = Font(15);
    [backView addSubview:noLinkLabel];
    [noLinkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).with.offset(12);
        make.width.mas_equalTo(KWIDTH);
        make.height.mas_equalTo(20);
        make.left.equalTo(backView);
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
    
    CGFloat width = 35;
    UIImage *image = [UIImage imageNamed:@"icon_shaixuan"];
    CGFloat height = image.size.height / image.size.width * width;
    UIButton *classifyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    classifyButton.frame = CGRectMake(KWIDTH - 12 - width, (H(self.navigationView) - STATUSBAR_HEIGHT  - height ) / 2 + STATUSBAR_HEIGHT, width, height);
    [classifyButton setImage:image forState:(UIControlStateNormal)];
    [classifyButton addTarget:self action:@selector(classify) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationView addSubview:classifyButton];
    
    [self.view addSubview:self.navigationView];
    [self.view bringSubviewToFront:self.navigationView];
}

- (void)classify {
    
    BOOL goTop = Y(self.classifyView) == MaxY(self.navigationView);
    
    self.darkView.hidden = goTop;
    [self.view bringSubviewToFront:self.classifyView];
    [self.view bringSubviewToFront:self.navigationView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.classifyView.frame;
        if (goTop) {
            frame.origin.y -= frame.size.height;
        } else {
            frame.origin.y += frame.size.height;
        }
        self.classifyView.frame = frame;
        
    }];
    

}

- (void)selectItem:(NSString *)item {
    
    [self classify];
    if ([item isEqualToString:@"全部"]) {
        self.category = IncomeDetailCategoryAll;
        
    } else if ([item isEqualToString:@"阅读收益"]) {
        self.category = IncomeDetailCategoryReadIncome;
    } else if ([item isEqualToString:@"广告收益"]) {
        self.category = IncomeDetailCategoryADIncome;
    } else if ([item isEqualToString:@"邀请收益"]) {
        self.category = IncomeDetailCategoryInvitedIncome;
    } else if ([item isEqualToString:@"活动收益"]) {
        self.category = IncomeDetailCategoryActiviryIncome;
    }
    [self requestIncomeDetailWithNew:YES category:(self.category) callback:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

- (UIView *)darkView {
    
    if (!_darkView) {
        _darkView = [[UIView alloc] initWithFrame:CGRectZero];
        _darkView.backgroundColor = TRAN_BLACK;
        [self.view addSubview:_darkView];
        [_darkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        _darkView.userInteractionEnabled = YES;
        [_darkView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classify)]];
    }
    return _darkView;
}

- (HHMineIncomeDetailClassifyView *)classifyView {
    
    if (!_classifyView) {
        CGFloat height = ceil(CGFLOAT_W(160));
        _classifyView = [[HHMineIncomeDetailClassifyView alloc] initWithFrame:CGRectMake(0, MaxY(self.navigationView) - height, KWIDTH, height)];
        _classifyView.delegate = self;
        [self.view addSubview:_classifyView];
    }
    return _classifyView;
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 0.01f)];
    [self.tableView registerClass:[HHIncomeDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHIncomeDetailTableViewCell class])];
   
    [self initHeader];
    [self initFooter];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self requestIncomeDetailWithNew:YES category:(self.category) callback:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMore {
    
    [self requestIncomeDetailWithNew:NO category:(self.category)  callback:^{
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
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == self.keys.count - 1 && self.footerString) {
        
        return 40;
        
    } else {
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 40)];
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

kRemoveCellSeparator

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH - 20 * 2, 40)];
    label.textColor = BLACK_153;
    NSString *key = self.keys[section];
    HHIncomeDetail *model = self.separateDict[key][0];
    label.text = model.timeArray[0];
    label.textAlignment = 2;
    label.font = Font(16);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.footerString && scrollView.contentOffset.y > 0) {
        self.tableView.bounces = NO;
    } else {
        self.tableView.bounces = YES;
    }
    
}


@end

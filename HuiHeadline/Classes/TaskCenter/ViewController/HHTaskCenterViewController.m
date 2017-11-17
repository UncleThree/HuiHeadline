//
//  HHTaskCenterViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskCenterViewController.h"
#import "HHTasKCenterHeaderView.h"
#import "HHTaskTableViewSectionHeaderView.h"
#import "HHTaskTableViewCell.h"
#import "HHTaskCellModel.h"
#import "HHTaskTableViewHeaderView.h"
#import "HHActivityTaskDetailWebViewController.h"
#import "WechatService.h"
#import "HHMineBindPhoneViewController.h"
#import "HHMineInvitedViewController.h"
#import "HHMallSegmentViewController.h"
#import "UIView+XDRefresh.h"

#import "CCPScrollView.h"

@interface HHTaskCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HHTaskCenterHeaderViewDelegate, HHTaskCellModelDelegate>

@property (nonatomic, strong)CCPScrollView *scrollView;

@property (nonatomic, strong)HHTasKCenterHeaderView *headerView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHTaskSectionHeaderModel *> *newbieHeaderModels;

@property (nonatomic, strong)NSMutableArray<HHTaskCellModel *> *newbieCellModels;

@property (nonatomic, strong)NSMutableArray<HHTaskSectionHeaderModel *> *dailyHeaderModels;

@property (nonatomic, strong)NSMutableArray<HHTaskCellModel *> *dailyCellModels;

@property (nonatomic, strong)UIView *statusBarView;

///高度缓存 优化性能
@property (nonatomic, strong)NSCache *heightCache;


@end

static HHTaskCenterViewController *taskCenterVC = nil;

@implementation HHTaskCenterViewController




- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

+ (instancetype)defaultTaskCenterVC {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskCenterVC = [[self class] new];
    });
    return taskCenterVC;
    
}

- (NSCache *)heightCache {
    
    if (!_heightCache) {
        _heightCache = [[NSCache alloc] init];
    }
    return _heightCache;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    
    if (!self.statusBarView) {
        self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, STATUSBAR_HEIGHT)];
        self.statusBarView.backgroundColor = RGB(230, 53, 40);
        [UIApplication.sharedApplication.keyWindow addSubview:self.statusBarView];
        [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.statusBarView];
    }
    
    if (self.scrollView) {
        [self.scrollView addTimer];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.statusBarView removeFromSuperview];
    self.statusBarView = nil;
    
    if (self.scrollView) {
        [self.scrollView removeTimer];
    }
    
   
}


    
    

///刷新之后放在刷新中
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    

}



- (void)viewDidLoad {
    
    [self initTableView];
    
    [super viewDidLoad];
    
    [self refresh];
    
    
}


- (void)refresh {
    ///签到信息
    [self reloadHeader:YES];
    ///任务
    [self reloadTableViewData:^{
        [self.tableView.mj_header endRefreshing];
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
    }];
    
}



///刷新任务中心 强制刷新重新请求 否则在登录后请求一次
- (void)reloadHeader:(BOOL)forced {
    
    if (!forced) {
        [self initHeaderView];
        return;
    }
    if ([HHUserManager sharedInstance].loginId) {
        
        [self requestAndReloadHeader];
        
    } else {
        [self initHeaderView];
    }
    
}

///任务信息
- (void)reloadTableViewData:(void(^)())callback  {
    
    if (!self.dailyCellModels.count) {
        [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    }
    
    ///新手任务
    [HHTaskCenterNetwork requstNewBieTaskList:^(id error, NSArray<HHUserNewbieTask *> *tasks) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            HHUserManager.sharedInstance.newbieTasks = tasks;
        }
        [self initNewbieModels:HHUserManager.sharedInstance.newbieTasks];
        
        ///日常任务
        [HHTaskCenterNetwork requestDailyTaskList:^(id error, HHUserDailyTaskResponse *response) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                HHUserManager.sharedInstance.dailyTaskResponse = response;
            }
            [self initDailyModels:HHUserManager.sharedInstance.dailyTaskResponse];
            [self.tableView reloadData];
            [HHHeadlineAwardHUD hideHUDAnimated:YES];
            if (callback) {
                callback();
            }
        }];
    }];
    
    
    
    
}


- (void)initDailyModels:(HHUserDailyTaskResponse *)response {
    
    NSArray<HHUserDailyTask *> *dailyTasks = response.dailyTaskList;
//    NSArray<HHUserDynamicTask *> *dynamicTasks = response.dynamicTaskList;
    NSArray<HHUserActivityTask *> *activityTasks = response.activityTaskList;
    
    if (!self.dailyHeaderModels) {
        self.dailyHeaderModels = [NSMutableArray array];
    }
    if (!self.dailyCellModels) {
        self.dailyCellModels = [NSMutableArray array];
    }
    [self.dailyHeaderModels removeAllObjects];
    [self.dailyCellModels removeAllObjects];
    
    NSInteger dynamicTaskReward = 0;
    NSInteger dynamicTaskState = 0;
    
    for (HHUserDailyTask *dailyTask in dailyTasks) {
        
        if (dailyTask.taskId > 6 || dailyTask.taskId < 1) {
            if (dailyTask.taskId == 101) {
                dynamicTaskReward = dailyTask.reward;
                dynamicTaskState = dailyTask.state;
            }
            continue;
        }
        HHTaskSectionHeaderModel *headerModel = [[HHTaskSectionHeaderModel alloc] init];
        headerModel.dailyTaskId = dailyTask.taskId;
        headerModel.title = [dailyTask taskDescription];
        headerModel.reward = [NSString stringWithFormat:@"+%zd",[dailyTask reward]];
        headerModel.open = NO;
        headerModel.type = 2;
        
        HHTaskCellModel *model = [[HHTaskCellModel alloc] init];
        model.dailyTaskId = dailyTask.taskId;
        model.title = [dailyTask taskRewardDescription];
        model.state = [dailyTask state];
        switch (model.state) {
            case 0:
                model.subText = [dailyTask btnDes];
                break;
            case 1:
                model.subText = @"立即领取";
                model.show = YES;
                headerModel.open = YES;
                break;
            case 2:
                model.subText = @"已完成";
                headerModel.completed = YES;
                break;
        }
        
        if ([G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]]) {
            model.show = YES;
            headerModel.open = YES;
        }
        ///暂时去掉分享任务
        if ([headerModel.title containsString:@"分享"]) {
            continue;
        }
        [self.dailyHeaderModels addObject:headerModel];
        [self.dailyCellModels addObject:model];
        
        
    }
//    for (HHUserDynamicTask *dynamicTask in dynamicTasks) {
//        HHTaskSectionHeaderModel *sectionModel = [[HHTaskSectionHeaderModel alloc] init];
//        sectionModel.dailyTaskId = 101;
//        sectionModel.title = [dynamicTask title];
//        sectionModel.reward = [NSString stringWithFormat:@"+%zd",dynamicTaskReward];
//        sectionModel.open = NO;
//        sectionModel.type = 2;
//        
//        
//        HHTaskCellModel *model = [[HHTaskCellModel alloc] init];
//        model.dailyTaskId = 101;
//        model.title = dynamicTask.rewardDes;
//        model.state = dynamicTaskState;
//        model.show = NO;
//        model.url = dynamicTask.url;
//        switch (model.state) {
//            case 0:
//                model.subText = dynamicTask.buttonDes;
//                break;
//            case 1:
//                model.subText = @"立即领取";
//                model.show = YES;
//                sectionModel.open = YES;
//                break;
//            case 2:
//                model.subText = @"已完成";
//                break;
//        }
//        if ([G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]]) {
//            model.show = YES;
//            sectionModel.open = YES;
//        }
//        [self.dailyHeaderModels addObject:sectionModel];
//        [self.dailyCellModels addObject:model];
//
//    }
    
    NSInteger activityTaskId = 777;
    NSArray *descs = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    activityTasks = [activityTasks sortedArrayUsingDescriptors:descs];
    for (HHUserActivityTask *activityTask in activityTasks) {
        
        HHTaskSectionHeaderModel *sectionModel = [[HHTaskSectionHeaderModel alloc] init];
        sectionModel.dailyTaskId = ++activityTaskId;
        sectionModel.title =  activityTask.title;
        sectionModel.open = NO;
        sectionModel.reward = [@"+" stringByAppendingString:activityTask.rewardDes];
        sectionModel.isRedPaper = YES;
        sectionModel.type = 2;
        
        HHTaskCellModel *model = [[HHTaskCellModel alloc] init];
        model.dailyTaskId = ++activityTaskId;
        model.title = activityTask.Description;
        model.subText = activityTask.buttonDes;
        model.url = activityTask.url;
        model.activityTitle = activityTask.title;
        if ([G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]]) {
            model.show = YES;
            sectionModel.open = YES;
        }
        [self.dailyHeaderModels insertObject:sectionModel atIndex:activityTask.order];
        [self.dailyCellModels insertObject:model atIndex:activityTask.order];
        
    }
    if (self.dailyHeaderModels.count) {
        [[self.dailyHeaderModels firstObject] setType:1];
        [[self.dailyHeaderModels lastObject] setType:3];
    }
    
    
    
}

- (void)initNewbieModels:(NSArray<HHUserNewbieTask *> *)tasks {
    
    if (!self.newbieHeaderModels) {
        self.newbieHeaderModels = [NSMutableArray array];
    }
    if (!self.newbieCellModels) {
        self.newbieCellModels = [NSMutableArray array];
    }
    [self.newbieHeaderModels removeAllObjects];
    [self.newbieCellModels removeAllObjects];
    
    if (!HHUserManager.sharedInstance.currentUser.userInfo.isNew) {
        return;
    }
    for (int i = 0; i < tasks.count; i++) {
        
        HHUserNewbieTask *task = tasks[i];
        
        HHTaskSectionHeaderModel *headerModel = [[HHTaskSectionHeaderModel alloc] init];
        headerModel.taskId = task.taskId;
        headerModel.title = task.taskDescription;
        headerModel.reward = [NSString stringWithFormat:@"+%zd",[tasks[i] reward]];
        headerModel.open = NO;
        headerModel.type = 2;
        
        
        HHTaskCellModel *model = [[HHTaskCellModel alloc] init];
        model.taskId = task.taskId;
        model.title = task.taskRewardDescription;
        model.state = task.state;
        model.show = NO;
        
        switch (model.state) {
            case 0:

                model.subText = task.taskButtonDes;
                break;
            case 1:
                model.subText = @"立即领取";
                model.show = YES;
                headerModel.open = YES;
                break;
            case 2:
                continue;
                break;
        }
        if ([G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"newbie%zd",model.taskId]]) {
            model.show = YES;
            headerModel.open = YES;
        }
        ///暂时去掉分享任务
        if ([headerModel.title containsString:@"分享"]) {
            continue;
        }
        [self.newbieHeaderModels addObject:headerModel];
        [self.newbieCellModels addObject:model];
        
        
    }
    if (self.newbieHeaderModels.count) {
        [[self.newbieHeaderModels firstObject] setType:1];
        [[self.newbieHeaderModels lastObject] setType:3];
    }
    
    
}

///签到信息
- (void)requestAndReloadHeader {
    
    
    [HHTaskCenterNetwork requestForSignRecord:^(id error, HHSignRecordResponse *response) {
        
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            [HHUserManager sharedInstance].signRecordResponse = response;
        }
        if ([[response mj_JSONObject] isEqualToDictionary:[HHUserManager.sharedInstance.signRecordResponse mj_JSONObject]] && self.headerView) {
            return ;
        }
        [self initHeaderView];
        
    }];
}


- (void)initHeaderView {
    
    self.headerView = nil;
    [self.scrollView removeTimer];

    
    self.headerView = [[HHTasKCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 730 / 3 + 5 - (LARGE ? 0 : (NORMAL ? 5 : 10))) response:[HHUserManager sharedInstance].signRecordResponse];
    self.headerView.delegate = self;
    
    self.scrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 25)];
    
    self.scrollView.titleArray = @[@""];
    
    self.scrollView.BGColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    
    [self.headerView addSubview:self.scrollView];
    
    self.tableView.tableHeaderView = self.headerView;
    
}





- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
//    self.tableView.bounces = NO;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[HHTaskTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHTaskTableViewCell class])];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
//    [self.view XD_refreshWithObject:self.tableView atPoint:CGPointMake(10, Y(self.view) -20 - 30 ) downRefresh:^{
//        //开始刷新
//        [self reloadHeader:YES];
//        [self reloadTableViewData:^{
//            [self.view XD_endRefresh];
//        }];
//
//    }];
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    CGPoint offset = self.tableView.contentOffset;

    if (offset.y < -20) {
        
        [HHHeadlineAwardHUD showHUDWithText:@"正在刷新..." animated:YES];
        [self refresh];
        
        offset.y = -20;

    }
    self.tableView.contentOffset = offset;
    
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.newbieCellModels.count > 0) + self.newbieCellModels.count + (self.dailyCellModels.count > 0) + self.dailyCellModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || (self.newbieCellModels.count > 0 && indexPath.section == self.newbieCellModels.count + 1) ) {
        
        return 0;
        
    } else  {
        
        HHTaskCellModel *model = nil;
        BOOL isNewbie = self.newbieCellModels.count && indexPath.section < self.newbieCellModels.count + 1 ;
        if (isNewbie) {
            
            model = self.newbieCellModels[indexPath.section - 1];
            
        } else {
            model = self.dailyCellModels[indexPath.section - 1 - (self.newbieCellModels.count > 0) - self.newbieCellModels.count];
        }
        
        NSNumber *key = [NSNumber numberWithInteger:indexPath.section];
        CGFloat cacheHeight = [[self.heightCache objectForKey:key] floatValue];
        
        if (model.show) {
            if (cacheHeight) {
                return cacheHeight;
            } else {
                CGFloat height = [model heightForModel];
                [self.heightCache setObject:[NSNumber numberWithFloat:height] forKey:key];
                return height;
            }
        } else {
            
            return 0;
        }
        
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 || ( self.newbieCellModels.count && indexPath.section == self.newbieCellModels.count + 1) ) {
        
        return [UITableViewCell new];
    } else {
        
        
        HHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHTaskTableViewCell class]) forIndexPath:indexPath];
        if (self.newbieCellModels.count && indexPath.section < self.newbieCellModels.count + 1) {
            cell.model = self.newbieCellModels[indexPath.section - 1];
        } else {
            cell.model = self.dailyCellModels[indexPath.section - 1 - (self.newbieCellModels.count > 0) - self.newbieCellModels.count];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || (self.newbieCellModels.count && section == self.newbieCellModels.count + 1 ) ) {
        
        
        
        NSString *title = @"";
        if (self.newbieCellModels.count && section == 0) {
            title = @"新手任务";
        } else {
            title = @"日常任务";
        }
        HHTaskTableViewHeaderView *header = [[HHTaskTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) title:title];
        header.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, H(header) - 0.5, KWIDTH, 0.5)];
        line.backgroundColor = RGB(220, 220, 220);
        [header addSubview:line];
        return header;
        
    } else {
        HHTaskTableViewSectionHeaderView *sectionHeader = nil;
        if (self.newbieCellModels.count && section < self.newbieCellModels.count + 1) {
            sectionHeader = [[HHTaskTableViewSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) model:self.newbieHeaderModels[section - 1]];
        } else {
            sectionHeader = [[HHTaskTableViewSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) model:self.dailyHeaderModels[section - 1 - (self.newbieCellModels.count > 0) - self.newbieHeaderModels.count]];
        }
        sectionHeader.backgroundColor = [UIColor whiteColor];
        sectionHeader.userInteractionEnabled = YES;
        sectionHeader.tag = 99 + section;
        [sectionHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionHeader:)]];
        
        
        return sectionHeader;
    }
    
}



- (void)tapSectionHeader:(UITapGestureRecognizer *)tap {
    
    NSUInteger index = tap.view.tag - 99;
    [self selectHeaderAtIndex:index];
    
}



- (void)selectHeaderAtIndex:(NSUInteger)index {
    
    
    
    HHTaskSectionHeaderModel *sectionModel = nil;
    HHTaskCellModel *cellModel = nil;
    BOOL isNewbie = self.newbieHeaderModels.count && index <= self.newbieHeaderModels.count;
    BOOL open = NO;
    if (isNewbie) {
        
        sectionModel = self.newbieHeaderModels[index - 1];
        sectionModel.open =  !sectionModel.open;
        [self.newbieHeaderModels replaceObjectAtIndex:index - 1 withObject:sectionModel];
        
        cellModel = self.newbieCellModels[index - 1];
        cellModel.show =  !cellModel.show;
        [self.newbieCellModels replaceObjectAtIndex:index - 1 withObject:cellModel];
        
        open = cellModel.show;
        
    } else {
        NSInteger count = 1 + (self.newbieCellModels.count > 0);
        sectionModel = self.dailyHeaderModels[index - self.newbieHeaderModels.count - count];
        sectionModel.open =  !sectionModel.open;
        [self.dailyHeaderModels replaceObjectAtIndex:index - self.newbieHeaderModels.count - count withObject:sectionModel];
        
        cellModel = self.dailyCellModels[index - self.newbieHeaderModels.count - count];
        cellModel.show =  !cellModel.show;
        [self.dailyCellModels replaceObjectAtIndex:index - self.newbieHeaderModels.count - count withObject:cellModel];
        open = cellModel.show;
    }
    
    [self cacheClickState:cellModel isNewbie:isNewbie];
    [self.tableView reloadData];
    
    NSInteger section = [[self.tableView indexPathsForVisibleRows] lastObject].section;
    
    if (section == index && open) {
        
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
    
}

- (void)cacheClickState:(HHTaskCellModel *)cellModel isNewbie:(BOOL)isNewbie {
    if (cellModel.show) {
        if (isNewbie) {
            [G.$.taskCenterCache setObject:@YES forKey:[NSString stringWithFormat:@"%@%zd",@"newbie",cellModel.taskId]];
        } else {
            [G.$.taskCenterCache setObject:@YES forKey:[NSString stringWithFormat:@"%@%zd",@"daily",cellModel.dailyTaskId]];
        }
        
    } else {
        
        if (isNewbie) {
            [G.$.taskCenterCache removeObjectForKey:[NSString stringWithFormat:@"%@%zd", @"newbie" ,cellModel.taskId]];
        } else {
            [G.$.taskCenterCache removeObjectForKey:[NSString stringWithFormat:@"%@%zd", @"daily",cellModel.dailyTaskId]];
        }
        
    }
}


#pragma mark UITableViewDelegate




#pragma mark HeaderViewDelegate

- (void)taskCenterHeaderViewClickSign {
    
    [HHTaskCenterNetwork sign:^(id error, HHSignResponse *response) {
        
        if (response.statusCode == 200) {
            
            
            [HHHeadlineAwardHUD showImageView:@"签到成功" coins:response.signCredit animation:NO originCenter:self.view.center addToView:self.view duration:1.0];
            [self reloadHeader:YES];
            
        } else if (response.statusCode == -50 && [HHUserManager sharedInstance].signRecordResponse.state == 1) {
            
            [HHHeadlineAwardHUD showMessage:@"您今天已签到!" animated:YES duration:2];
            
            
        } else {
            
            NSLog(@"%@",response.msg);
        }
    }];
    
}

- (void)taskCenterHeaderViewClickHowToMakeMoney {
    
    HHActivityTaskDetailWebViewController *webVC = [HHActivityTaskDetailWebViewController new];
    webVC.activityTitle = @"惠头条常见问题";
    webVC.URLString =  k_common_problem;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    

}

#pragma mark HHTaskModelDelegate




- (void)taskTableViewCellDidClickTaskId:(NSInteger)taskId
                               isNewbie:(BOOL)isNewbie
                                  title:(NSString *)title
                                    url:(NSString *)url{
    if (isNewbie) {
        switch (taskId) {
            case BIND_PHONE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                [self bindPhone];
                
                break;
            }
            case BIND_WEIXIN:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                [self bindWechat];
                
                break;
            }
            case READ_ONE:
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title];
                break;
            case VIDEO_ONE:
                [self drawToIndex:1 isNewbie:isNewbie taskId:taskId title:title];
                break;
            case WITHDRAW_CASH:
                
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    HHMallSegmentViewController *vc = [HHMallSegmentViewController new];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                    
                } else {
                    [self alertAction];
                }
                
                break;
            }
            case FIRST_APPRENTICE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                [self pushInvitedVC];
                break;
            }
        }
    } else {
        switch (taskId) {
            case INVITE_APPRENTICE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                [self pushInvitedVC];
                
                break;
            }
            case NEWS_SHARE:
            {
                
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title];
                break;
            }
            case SHARE_FRIEND_CIRCLE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                if ([title isEqualToString:@"立即收徒"]) {
                    
                    [self pushInvitedVC];
                } else {
                    NSLog(@"分享到朋友圈收徒");
                    
                }
                break;
            }
            case SHARE_WEIXIN_GROUP:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                if ([title isEqualToString:@"立即收徒"]) {
                    
                    [self pushInvitedVC];
                } else {
                    NSLog(@"分享微信群");
                }
                
                break;
            }
            case READ_FIVE:
            {
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title];
                break;
            }
            case VIDEO_FIVE:
            {
                [self drawToIndex:1 isNewbie:isNewbie taskId:taskId title:title];
                
                break;
            }
            case AD_LIST_101:
            {
                if (url) {
                    [[UIApplication sharedApplication] openURL:URL(url)];
                }
                break;
            }

        }
        
    }
    
    
}

- (void)alertAction {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您只需要完成以上四个任务，该奖励将自动赠送给您" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"朕知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)pushInvitedVC {
    
    HHMineInvitedViewController *vc = [HHMineInvitedViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)bindPhone {
    
    HHMineBindPhoneViewController *bindPhoneVC = [[HHMineBindPhoneViewController alloc] init];
    bindPhoneVC.callback = ^(NSString *phone) {
        
        HHUserModel *user = [HHUserManager sharedInstance].currentUser;
        user.userInfo.phone = phone;
        [HHUserManager sharedInstance].currentUser = user;
        [self reloadTableViewData:nil];
    };
    bindPhoneVC.countdown = [HHUserManager sharedInstance].virifyCodeCountdown;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindPhoneVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)bindWechat {
    
    [[WechatService sharedWechat] bindToWechat:^(id error, id result) {
        
        [HHHeadlineAwardHUD showMessage:error?:result animated:YES duration:2];
        [self reloadTableViewData:nil];
    }];
}

- (void)activityTaskTitle:(NSString *)title url:(NSString *)url {
    
    if (!url) {
        return;
    }
    HHActivityTaskDetailWebViewController *webVC = [HHActivityTaskDetailWebViewController new];
    webVC.URLString = url;
    webVC.activityTitle = title;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



- (void)drawToIndex:(NSUInteger )index
           isNewbie:(BOOL)isNewbie
             taskId:(NSInteger)taskId
              title:(NSString *)title{
    
    if ([title isEqualToString:@"立即领取"]) {
        [self draw:taskId isNewbie:isNewbie];
    } else if ([title isEqualToString:@"已完成"]) {
        NSLog(@"已完成 不作处理");
    } else {
        [G.$.rootVC setSelectedIndex:index];
    }
    
    
}

- (void)draw:(NSInteger)taskId isNewbie:(BOOL)isNewbie {
    
    [HHTaskCenterNetwork drawTaskReward:isNewbie taskId:taskId callback:^(id error, HHUserDrawTaskRewardResponse *response) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            [HHHeadlineAwardHUD showImageView:@"领取成功" coins:0 animation:NO originCenter:self.view.center addToView:self.view duration:1.0];
            
        }
        [self reloadTableViewData:nil];
    }];
}



@end

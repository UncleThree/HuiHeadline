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
#import "CustomBrowserViewController.h"
#import "WechatService.h"
#import "HHMineBindPhoneViewController.h"
#import "HHMineRebindPhoneViewController.h"
#import "HHMineInvitedViewController.h"
#import "HHMallSegmentViewController.h"
#import "CCPScrollView.h"
#import "HHMineInvitedOneImageTableViewCell.h"
#import "ActivityModel.h"
#import "OpenActivityUtil.h"
#import "ImageYS.h"
#import <Social/Social.h>

@interface HHTaskCenterViewController ()<UITableViewDataSource, UITableViewDelegate, HHTaskCenterHeaderViewDelegate, HHTaskCellModelDelegate, HHMineInvitedImageTableViewCellDelegate>

@property (nonatomic, strong)CCPScrollView *scrollView;

@property (nonatomic, strong)HHTasKCenterHeaderView *headerView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHTaskSectionHeaderModel *> *newbieHeaderModels;

@property (nonatomic, strong)NSMutableArray<HHTaskCellModel *> *newbieCellModels;

@property (nonatomic, strong)NSMutableArray<HHTaskSectionHeaderModel *> *dailyHeaderModels;

@property (nonatomic, strong)NSMutableArray<HHTaskCellModel *> *dailyCellModels;

@property (nonatomic,strong)HHInvitedItem *bannerModel;



///高度缓存 优化性能
@property (nonatomic, strong)NSCache *heightCache;

@property (nonatomic, assign)BOOL freshTag;

@property (nonatomic, assign)NSUInteger experienceTime;

@property (nonatomic, assign)NSTimeInterval dyTaskStartTime;

@property (nonatomic, assign)NSInteger currentDynamicTaskId;

@property (nonatomic, copy)NSString *myInviteCode;

@end

static HHTaskCenterViewController *taskCenterVC = nil;

@implementation HHTaskCenterViewController



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
    
    
    if (self.scrollView) {
        [self.scrollView addTimer];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.scrollView) {
        [self.scrollView removeTimer];
    }
    
   
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
    

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self refresh];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(becomeActive) name:@"applicationDidBecomeActive" object:nil];
    
    ///滑动返回没有奖励的Bug
    [self becomeActive];

}



- (void)viewDidLoad {
    
    
    [self initTableView];
    
    [super viewDidLoad];
    
    
}


- (void)refresh {
    ///签到信息
    [self reloadHeader:YES];
    ///任务
    [self reloadTableViewData];
    
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

- (void)requestNewBieTask:(void(^)())callback {
    
    ///新手任务
    [HHTaskCenterNetwork requstNewBieTaskList:^(id error, NSArray<HHUserNewbieTask *> *tasks) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            HHUserManager.sharedInstance.newbieTasks = tasks;
        }
        [self initNewbieModels:HHUserManager.sharedInstance.newbieTasks];
        callback();
    }];
}

- (void)requstDailyTask:(void(^)())callback {
 
    ///日常任务
    [HHTaskCenterNetwork requestDailyTaskList:^(id error, HHUserDailyTaskResponse *response) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            HHUserManager.sharedInstance.dailyTaskResponse = response;
        }
        [self initDailyModels:HHUserManager.sharedInstance.dailyTaskResponse];
        callback();
        
    }];
}

- (void)requestBanner:(void(^)())callback {
    
    [HHTaskCenterNetwork getBannerInfoWithPosition:3 callback:^(id error, BannerInfo *bannerInfo) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            HHUserManager.sharedInstance.taskBannerInfo = bannerInfo;
            [self initBannerModel:bannerInfo callback:callback];
        }
    }];
    
}

///任务信息
- (void)reloadTableViewData  {
    
    if (!self.dailyCellModels.count) {
        [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    }
    
    [self requestBanner:^{
        [self.tableView reloadData];
    }];
    [self requestNewBieTask:^{
        
        [self.tableView reloadData];
    }];
    [self requstDailyTask:^{
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        
    }];
    
}

- (void)initBannerModel:(BannerInfo *)bannerInfo
               callback:(void(^)())callback{
    
    if (!self.bannerModel) {
        self.bannerModel = [[HHInvitedItem alloc] init];
    }
    self.bannerModel.imgUrl = bannerInfo.picture;
    self.bannerModel.targetLinkUrl = bannerInfo.url;
    self.bannerModel.isBanner = YES;
    [AsyncImageUtil checkCache:self.bannerModel.imgUrl callback:callback];
    
}



- (void)initDailyModels:(HHUserDailyTaskResponse *)response {
    
    NSArray<HHUserDailyTask *> *dailyTasks = response.dailyTaskList;
    NSArray<HHUserDynamicTask *> *dynamicTasks = response.dynamicTaskList;
    NSArray<HHUserActivityTask *> *activityTasks = response.activityTaskList;
    
    if (!self.dailyHeaderModels) {
        self.dailyHeaderModels = [NSMutableArray array];
    }
    if (!self.dailyCellModels) {
        self.dailyCellModels = [NSMutableArray array];
    }
    [self.dailyHeaderModels removeAllObjects];
    [self.dailyCellModels removeAllObjects];
    
    NSMutableDictionary *dynamicTaskDict = @{}.mutableCopy;
    
    for (HHUserDailyTask *dailyTask in dailyTasks) {
        
        if (dailyTask.taskId > 6 || dailyTask.taskId < 1) {
            if (dailyTask.taskId > 100 && dailyTask.taskId <= 300) {
                [dynamicTaskDict setObject:@{@"reward":@(dailyTask.reward),@"state":@(dailyTask.state)} forKey:@(dailyTask.taskId)];
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
        model.title = dailyTask.taskRewardDescription;
        model.state = dailyTask.state;
        model.visit = dailyTask.visit;
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
        if ([[G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]] boolValue]) {
            model.show = YES;
            headerModel.open = YES;
        }
        
        if (model.dailyTaskId == SHARE_FRIEND_CIRCLE || model.dailyTaskId == SHARE_WEIXIN_GROUP) {
            ///暂时去掉分享任务
//            continue;
        }
        [self.dailyHeaderModels addObject:headerModel];
        [self.dailyCellModels addObject:model];
        
        
    }
    if (dynamicTasks.count > 0 && !G.$.bs) {
        for (HHUserDynamicTask *dynamicTask in dynamicTasks) {
            
            if (![dynamicTaskDict.allKeys containsObject:@(dynamicTask.Id)]) {
                continue;
            }
            HHTaskSectionHeaderModel *sectionModel = [[HHTaskSectionHeaderModel alloc] init];
            sectionModel.dailyTaskId = dynamicTask.Id;
            sectionModel.title = [dynamicTask title];
            sectionModel.reward = [NSString stringWithFormat:@"+%zd",[[[dynamicTaskDict objectForKey:@(dynamicTask.Id)] objectForKey:@"reward"] integerValue] ];
            sectionModel.open = NO;
            sectionModel.type = 2;
            
            self.experienceTime = dynamicTask.experienceTime;
            
            HHTaskCellModel *model = [[HHTaskCellModel alloc] init];
            model.dailyTaskId = dynamicTask.Id;
            model.title = dynamicTask.rewardDes;
            model.state = [[[dynamicTaskDict objectForKey:@(dynamicTask.Id)] objectForKey:@"state"] integerValue];
            model.show = NO;
            model.url = dynamicTask.url;
            model.visit = dynamicTask.visit;
            switch (model.state) {
                case 0:
                    model.subText = dynamicTask.buttonDes;
                    break;
                case 1:
                    model.subText = @"立即领取";
                    model.show = YES;
                    sectionModel.open = YES;
                    break;
                case 2:
                    model.subText = @"已完成";
                    sectionModel.completed = YES;
                    break;
            }
            if ([[G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]] boolValue]) {
                model.show = YES;
                sectionModel.open = YES;
            }
            [self.dailyHeaderModels addObject:sectionModel];
            [self.dailyCellModels addObject:model];
            
        }
    }

    
    NSInteger activityTaskId = 777;
    NSArray *descs = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:NO]];
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
        model.visit = activityTask.visit;
        
        if ([[G.$.taskCenterCache objectForKey:[NSString stringWithFormat:@"daily%zd",model.dailyTaskId]] boolValue]) {
            model.show = YES;
            sectionModel.open = YES;
        }
        [self.dailyHeaderModels insertObject:sectionModel atIndex:activityTask.order - 1];
        [self.dailyCellModels insertObject:model atIndex:activityTask.order - 1];
        
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
            
            if ([[response mj_JSONObject] isEqualToDictionary:[HHUserManager.sharedInstance.signRecordResponse mj_JSONObject]] && self.headerView) {
                return ;
            } else {
                [HHUserManager sharedInstance].signRecordResponse = response;
            }
        }
        
        [self initHeaderView];
        
    }];
}


- (void)initHeaderView {
    
    self.headerView = nil;
    [self.scrollView removeTimer];

    CGFloat pad = G.$.bs ? 0 : 20;
    self.headerView = [[HHTasKCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 715 / 3 - (LARGE ? 0 : (NORMAL ? 5 : 10)) + pad) response:[HHUserManager sharedInstance].signRecordResponse];
    self.headerView.delegate = self;
    
    self.scrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, KWIDTH, 25)];
    
    self.scrollView.titleArray = @[@""];
    
    self.scrollView.BGColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    
    if (!G.$.bs) {
        [self.headerView addSubview:self.scrollView];
    }
    
    self.tableView.tableHeaderView = self.headerView;
    

}





- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(-STATUSBAR_HEIGHT);
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[HHTaskTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHTaskTableViewCell class])];
    [self.tableView registerClass:[HHMineInvitedOneImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineInvitedOneImageTableViewCell class])];
    
    _tableView.estimatedRowHeight = 0.0f;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    

    
}






#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + (self.newbieCellModels.count > 0) + self.newbieCellModels.count + (self.dailyCellModels.count > 0) + self.dailyCellModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)heightForBanner {
    
    if (self.bannerModel) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.bannerModel.imgUrl];
        if (image) {
            return image.size.height / image.size.width * KWIDTH;
        }
    }
    return 0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 ) {

        return HHUserManager.sharedInstance.taskBannerInfo ? [self heightForBanner] : 0;
    }
    if (indexPath.section == 1 || (self.newbieCellModels.count > 0 && indexPath.section == self.newbieCellModels.count + 2) ) {

        return 0;

    } else  {

        HHTaskCellModel *model = nil;
        BOOL isNewbie = self.newbieCellModels.count && indexPath.section < self.newbieCellModels.count + 2 ;
        if (isNewbie) {

            model = self.newbieCellModels[indexPath.section - 2];

        } else {
            model = self.dailyCellModels[indexPath.section - 2 - (self.newbieCellModels.count > 0) - self.newbieCellModels.count];
        }

        if (!model.show) {
            return 0;
        }
        NSNumber *key = [NSNumber numberWithInteger:indexPath.section];
        CGFloat cacheHeight = [[self.heightCache objectForKey:key] floatValue];
        if (cacheHeight) {
            return cacheHeight;
        } else {
            CGFloat height = [model heightForModel];
            [self.heightCache setObject:[NSNumber numberWithFloat:height] forKey:key];
            return height;
        }
    }


}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 && HHUserManager.sharedInstance.taskBannerInfo) {
        return CGFLOAT(12);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return HHUserManager.sharedInstance.taskBannerInfo ? CGFLOAT(12) : 0;
    }
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HHMineInvitedOneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineInvitedOneImageTableViewCell class]) forIndexPath:indexPath];
        cell.model = self.bannerModel;
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.section == 1 || ( self.newbieCellModels.count && indexPath.section == self.newbieCellModels.count + 2) ) {
        
        return [UITableViewCell new];
        
    } else {
        
        
        HHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHTaskTableViewCell class]) forIndexPath:indexPath];
        if (self.newbieCellModels.count && indexPath.section < self.newbieCellModels.count + 2) {
            cell.model = self.newbieCellModels[indexPath.section - 2];
        } else {
            cell.model = self.dailyCellModels[indexPath.section - 2 - (self.newbieCellModels.count > 0) - self.newbieCellModels.count];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return [UIView new];
    }
    
    if (section == 1 || (self.newbieCellModels.count && section == self.newbieCellModels.count + 2) ) {
        
        NSString *title = @"";
        if (self.newbieCellModels.count && section == 1) {
            title = @"新手任务";
        } else {
            title = @"日常任务";
        }
        HHTaskTableViewHeaderView *header = [[HHTaskTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) title:title];
        header.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, H(header) - 0.5, KWIDTH, 0.5)];
        line.backgroundColor = SEPRATE_COLOR;
        [header addSubview:line];
        return header;
        
    } else {
        HHTaskTableViewSectionHeaderView *sectionHeader = nil;
        if (self.newbieCellModels.count && section < self.newbieCellModels.count + 2) {
            sectionHeader = [[HHTaskTableViewSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) model:self.newbieHeaderModels[section - 2]];
        } else {
            sectionHeader = [[HHTaskTableViewSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50) model:self.dailyHeaderModels[section - 2 - (self.newbieCellModels.count > 0) - self.newbieHeaderModels.count]];
        }
        sectionHeader.backgroundColor = [UIColor whiteColor];
        sectionHeader.userInteractionEnabled = YES;
        sectionHeader.tag = 99 + section;
        [sectionHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionHeader:)]];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, H(sectionHeader) - 0.5, KWIDTH, 0.5)];
        line.backgroundColor = SEPRATE_COLOR;
        [sectionHeader addSubview:line];
        
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
    BOOL isNewbie = self.newbieHeaderModels.count && index  < self.newbieHeaderModels.count + 2;
    BOOL open = NO;
    if (isNewbie) {
        
        sectionModel = self.newbieHeaderModels[index - 2];
        sectionModel.open =  !sectionModel.open;
        [self.newbieHeaderModels replaceObjectAtIndex:index - 2 withObject:sectionModel];
        
        cellModel = self.newbieCellModels[index - 2];
        cellModel.show =  !cellModel.show;
        [self.newbieCellModels replaceObjectAtIndex:index - 2 withObject:cellModel];
        
        open = cellModel.show;
        
    } else {
        NSInteger count = 2 + (self.newbieCellModels.count > 0);
        sectionModel = self.dailyHeaderModels[index  - self.newbieHeaderModels.count - count];
        sectionModel.open =  !sectionModel.open;
        [self.dailyHeaderModels replaceObjectAtIndex:index - self.newbieHeaderModels.count - count withObject:sectionModel];
        
        cellModel = self.dailyCellModels[index - self.newbieHeaderModels.count - count];
        cellModel.show =  !cellModel.show;
        [self.dailyCellModels replaceObjectAtIndex:index - self.newbieHeaderModels.count - count withObject:cellModel];
        open = cellModel.show;
    }
    
    [self cacheClickState:cellModel isNewbie:isNewbie];

    
    NSInteger section = [[self.tableView indexPathsForVisibleRows] lastObject].section;
    
    
//    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationNone)];
//    }];
    
    if (section == index && open) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
    
}

- (void)cacheClickState:(HHTaskCellModel *)cellModel isNewbie:(BOOL)isNewbie {
    
    
    if (isNewbie) {
        [G.$.taskCenterCache setObject:@(cellModel.show) forKey:[NSString stringWithFormat:@"%@%zd",@"newbie",cellModel.taskId]];
    } else {
        [G.$.taskCenterCache setObject:@(cellModel.show) forKey:[NSString stringWithFormat:@"%@%zd",@"daily",cellModel.dailyTaskId]];
    }

}

#pragma mark HHMineInvitedImageTableViewCellDelegate

- (void)clickBanner:(NSString *)link {
    
    if ([link containsString:@"{"]) {
        
        ActivityModel *model = [ActivityModel mj_objectWithKeyValues:[link mj_JSONObject]];
        [OpenActivityUtil pushViewControllerWithModel:model originVC:self hideBottom:YES];
        
    } else {
        CustomBrowserViewController *webVC = [CustomBrowserViewController new];
        webVC.URLString = link;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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
    
    CustomBrowserViewController *webVC = [CustomBrowserViewController new];
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
                                    url:(NSString *)url
                                  visit:(BOOL)visit{
    if (isNewbie) {
        switch (taskId) {
            case BIND_PHONE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }  else {
                    [self bindPhone:NO];
                }
                
                
                break;
            }
            case BIND_WEIXIN:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                } else if (([title isEqualToString:@"已完成"] )) {
                    if (visit)
                    [self bindWechat];
                } else {
                    [self bindWechat];
                }
                
                break;
            }
            case READ_ONE:
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title visit:visit];
                break;
            case VIDEO_ONE:
                [self drawToIndex:1 isNewbie:isNewbie taskId:taskId title:title visit:visit];
                break;
            case WITHDRAW_CASH:
                
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    HHMallSegmentViewController *vc = [HHMallSegmentViewController new];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                    
                }   else {
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
                } else if ([title isEqualToString:@"已完成"] ) {
                    if (visit)
                    [self pushInvitedVC];
                } else {
                    [self pushInvitedVC];
                }
                
                
                break;
            }
            case NEWS_SHARE:
            {
                
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title visit:visit];
                
                break;
            }
            case SHARE_FRIEND_CIRCLE:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                else if ([title isEqualToString:@"已完成"] ) {
                    if (visit)
                        [self shareToWechat:YES callback:nil];
                }
                else {
                    
                    [self shareToWechat:YES callback:^(BOOL success) {
                        if (success) {
                            [self completeDailyTaskWithTaskId:taskId callback:^(BOOL success) {
                                if (success) {
                                    [self reloadTableViewData];
                                } else {
                                    
                                }
                            }];
                        }
                    }];
                    
                    
                }
                break;
            }
            case SHARE_WEIXIN_GROUP:
            {
                if ([title isEqualToString:@"立即领取"]) {
                    
                    [self draw:taskId isNewbie:isNewbie];
                    return;
                }
                else if ([title isEqualToString:@"已完成"] ) {
                    if (visit)
                        [self shareToWechat:NO callback:nil];
                }  else {
                    [self shareToWechat:NO callback:^(BOOL success) {
                        if (success) {
                            [self completeDailyTaskWithTaskId:taskId callback:^(BOOL success) {
                                if (success) {
                                    [self reloadTableViewData];
                                } else {
                                    
                                }
                            }];
                        }
                    }];
                }
                
                break;
            }
            case READ_FIVE:
            {
                [self drawToIndex:0 isNewbie:isNewbie taskId:taskId title:title visit:visit];
                break;
            }
            case VIDEO_FIVE:
            {
                [self drawToIndex:1 isNewbie:isNewbie taskId:taskId title:title visit:visit];
                
                break;
            }
            default: {
                
                if (taskId > 100 && taskId <= 200) {
                    
                    if ([title isEqualToString:@"立即领取"]) {
                        [self draw:taskId isNewbie:isNewbie];
                        
                        
                    }  else if ([title isEqualToString:@"已完成"]) {
                        
                        if (visit)
                            [self pushToSafary:url];
                    }
                    else {
                        
                        [self pushToSafary:url];
                        self.dyTaskStartTime = [[NSDate date] timeIntervalSince1970];
                        self.currentDynamicTaskId = taskId;
                    }
                    
                }
                else if (taskId > 200 && taskId <= 300) {
                    
                    if ([title isEqualToString:@"立即领取"]) {
                        
                        [self draw:taskId isNewbie:isNewbie];
                        
                    } else if ([title isEqualToString:@"已完成"] ) {
                       
                        if (visit)
                        [self pushToWebVC:url title:@"惠头条"];
                        
                    }  else {
                        
                        [self pushToWebVC:url title:@"惠头条"];
                        self.dyTaskStartTime = [[NSDate date] timeIntervalSince1970];
                        self.currentDynamicTaskId = taskId;
                    }
                }
                else {
                    
                    NSLog(@"WTF::%zd",taskId);
                }
                break;
            }

        }
        
    }
    
    
}

- (void)requestMyInvitCode:(void(^)(NSString *code))callback {
    
    [HHHeadlineAwardHUD showHUDWithText:@"请稍后..." animated:YES];
    [HHMineNetwork requestInviteFetchSummary:^(id error, HHInvitedFetchSummaryResponse *response) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (response && response.userInviteInfo.code) {
            callback(response.userInviteInfo.code);
        } else {
            callback(nil);
        }
    }];
}

- (void)shareToWechat:(BOOL)isCircle
             callback:(void(^)(BOOL success))callback{
    
    if (self.myInviteCode) {
        
        [self presentShareVCWithCode:self.myInviteCode isCircle:isCircle callback:callback];
        return;
    }
    
    [self requestMyInvitCode:^(NSString *code) {
        if (!code) {
            [HHHeadlineAwardHUD showMessage:@"获取邀请码失败，请稍后再试" animated:YES duration:2.5];
        } else {
            self.myInviteCode = code;
            [self presentShareVCWithCode:code isCircle:isCircle callback:callback];
        }
        
    }];
    
    
}

- (void)alertFirstCircleShareMessage:(void(^)())callback {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"邀请码已经复制到剪切板，您可以在微信朋友圈分享页面长按粘贴您的邀请码然后发表~" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"朕知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        if (callback) {
            callback();
        }
    }];
    
    [alert addAction:shareAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)copyToPastbBoard:(NSString *)string {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}

- (void)share:(NSArray *)activityItems callback:(void (^)(BOOL))callback {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"] && completed) {
            if (callback) {
                callback(YES);
            }
            
        } else {
            if (callback) {
                callback(NO);
            }
        }
    };
    
    activityVC.excludedActivityTypes = @[
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePrint,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypeOpenInIBooks
                                         ];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)presentShareVCWithCode:(NSString *)code
                      isCircle:(BOOL)isCircle
                      callback:(void(^)(BOOL success))callback {
    
    NSString *textToShare = [NSString stringWithFormat:@"看新闻，赚零花，填我邀请码：%@ \n↓↓点击下载领取↓↓\n%@", code, k_ios_link];
    NSData *imgData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_logo" ofType:@"png"]];
    NSURL *urlToShare = [NSURL URLWithString:k_ios_link];
    
    UIImage *image1 = [UIImage imageNamed:@"share_wx_bg.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"share_wx_two_bg.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"share_wx_tir_bg.jpg"];
    NSArray *imgArr = [ImageYS getJPEGImagerImgArr:@[image1, image2, image3]];
    
    
    
    NSArray *activityItems = nil;
    if (isCircle) {
        activityItems = imgArr;
        if (activityItems.count == 3) {
            activityItems = @[UIImagePNGRepresentation(activityItems[0]),UIImagePNGRepresentation(activityItems[1]),UIImagePNGRepresentation(activityItems[2]) ];
        }
        
    } else {
        activityItems = @[textToShare, imgData, urlToShare];
        
        
    }
    if (isCircle) {
        
        [self copyToPastbBoard:textToShare];
        
        if ([(AppDelegate *)UIApplication.sharedApplication.delegate firstShareCircle]) {
            
            [self alertFirstCircleShareMessage:^{
                [self share:activityItems callback:callback];
            }];
            
        } else {
            
            [HHHeadlineAwardHUD showMessage:@"邀请码已复制到剪切板" animated:YES duration:2];
            [self share:activityItems callback:callback];
            
        }
        
        
    } else {
        
        [self share:activityItems callback:callback];
    }
    
    
    
}

- (void)becomeActive {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if (self.currentDynamicTaskId && self.experienceTime && self.dyTaskStartTime && (current - self.dyTaskStartTime) * 1000 >= self.experienceTime) {
        
        [self completeDailyTaskWithTaskId:self.currentDynamicTaskId callback:^(BOOL success) {
            
            self.dyTaskStartTime = 0;
            if (success) {
                [self reloadTableViewData];
            }
        }];
        
    } else {
        self.dyTaskStartTime = 0;
    }
    
}

- (void)completeDailyTaskWithTaskId:(NSInteger)taskId
                           callback:(void(^)(BOOL success))callback {
    
    [HHTaskCenterNetwork dailyTaskCompleted:taskId callback:^(id error, HHResponse *response) {
        if (response && response.statusCode == 200) {
            
            if (callback) {
                callback(YES);
            }
            
        } else {
            if (callback) {
                callback(NO);
            }
        }
        
    }];
    
}

- (void)activityTaskTitle:(NSString *)title url:(NSString *)url visit:(BOOL)visit {
    
    
    [self pushToWebVC:url title:title];
}

- (void)pushToSafary:(NSString *)url
{
    
    if (url) {
        [[UIApplication sharedApplication] openURL:URL(url)];
        
    }
}

- (void)pushToWebVC:(NSString *)url
              title:(NSString *)title{
    if (!url) {
        return;
    }
    CustomBrowserViewController *webVC = [CustomBrowserViewController new];
    webVC.callback = ^{
        [self becomeActive];
    };
    webVC.URLString = url;
    webVC.activityTitle = title;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



- (void)drawToIndex:(NSUInteger )index
           isNewbie:(BOOL)isNewbie
             taskId:(NSInteger)taskId
              title:(NSString *)title
              visit:(BOOL)visit{
    
    if ([title isEqualToString:@"立即领取"]) {
        [self draw:taskId isNewbie:isNewbie];
    } else if ([title isEqualToString:@"已完成"]) {
        
        if (visit)
            [G.$.rootVC setSelectedIndex:index];
    } else {
        [G.$.rootVC setSelectedIndex:index];
    }
    
    
}

- (void)draw:(NSInteger)taskId isNewbie:(BOOL)isNewbie {
    
    [HHTaskCenterNetwork drawTaskReward:isNewbie taskId:taskId callback:^(id error, HHUserDrawTaskRewardResponse *response) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            [HHHeadlineAwardHUD showImageView:@"领取成功" coins:response.reward animation:NO originCenter:self.view.center addToView:self.view duration:1.0];
            
        }
        [self reloadTableViewData];
    }];
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

- (void)bindPhone:(BOOL)hasBind {
    
    void (^callback)(NSString *phone) = ^(NSString *phone) {
        
        HHUserModel *user = [HHUserManager sharedInstance].currentUser;
        user.userInfo.phone = phone;
        [HHUserManager sharedInstance].currentUser = user;
        [self reloadTableViewData];
    };
    
    UIViewController *vc = nil;
    
    HHMineBindPhoneViewController *bindPhoneVC = [[HHMineBindPhoneViewController alloc] init];
    bindPhoneVC.callback = callback;
    bindPhoneVC.countdown = [HHUserManager sharedInstance].virifyCodeCountdown;
    vc = bindPhoneVC;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)bindWechat {
    
    [[WechatService sharedWechat] bindToWechat:^(id error, id result) {
        
        [HHHeadlineAwardHUD showMessage:error?:result animated:YES duration:2];
        [self reloadTableViewData];
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    if (y + 20 > H(self.headerView)) {
     
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}




@end

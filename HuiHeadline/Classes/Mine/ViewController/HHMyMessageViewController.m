//
//  HHMyMessageViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyMessageViewController.h"
#import "HHUserMessageListResponse.h"
#import "HHMyMessageTableViewCell.h"

@interface HHMyMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<HHUserMessage *> *messages;

@end

@implementation HHMyMessageViewController


- (NSMutableArray<HHUserMessage *> *)messages {
    
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    
    [self initNav];
    
    [self initTableView];
    
    [super viewDidLoad];
    
    [self requestMessages:YES];
    
}

- (void)initNav {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 消息列表"];
    [self.view addSubview:self.navigationView];
    

}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)refresh {
    
    [super refresh];
    
    [self requestMessages:NO];
    
}

- (void)requestMessages:(BOOL)first {
    
    [HHMineNetwork requestMyMessagesWithMessageId:self.messages.lastObject ? self.messages.lastObject.message_id : 0 callback:^(id error, NSArray<HHUserMessage *> *messages) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            if (!messages.count) {
                self.tableView.mj_header = nil;
                self.tableView.bounces = NO;
            }
            [self.messages addObjectsFromArray:messages];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (first)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.messages.count - 1] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
        }
        
        
    }];
    
}
- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 12;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,_tableView.bounds.size.width,0.01f)];
    //    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHMyMessageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMyMessageTableViewCell class])];
   
    [self initHeader];
}

- (void)initHeader {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}



#pragma  mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.messages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHUserMessage *message = self.messages[self.messages.count - indexPath.section - 1];
//    if (indexPath.row == 0) {
//        return 40;
//    }
    return [message heightForMessage];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//
//
//    }
    HHMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMyMessageTableViewCell class]) forIndexPath:indexPath];
    cell.message = self.messages[self.messages.count - indexPath.section - 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 0) {
        self.tableView.bounces = NO;
    } else {
        self.tableView.bounces = YES;
    }
}




@end

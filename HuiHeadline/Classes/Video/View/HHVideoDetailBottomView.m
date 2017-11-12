//
//  HHVideoDetailBottomView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoDetailBottomView.h"
#import "HHHeadlineNewsLeftRightTableViewCell.h"

@interface HHVideoDetailBottomView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *backTableView;




@end

static NSString *identifier = @"VIDEO_AD_CELL";

@implementation HHVideoDetailBottomView


- (void)setProgress:(CGFloat)progress {
    
    self.progressView.progressView.progress = progress;
}

- (CGFloat)progress {
    
    return self.progressView.progressView.progress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}


- (void)initUI:(CGRect)frame {
    
    self.backTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    self.backTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.backTableView.dataSource = self;
    self.backTableView.delegate = self;
    self.backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backTableView.bounces = NO;
    [self.backTableView registerNib:[UINib nibWithNibName:@"HHHeadlineNewsLeftRightTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    [self addSubview:self.backTableView];
    self.progressView = [[HHHeadlineNewsDetailProgressView alloc] initWithFrame:CGRectMake(0, 0, PROGRESS_KWIDTH, PROGRESS_KWIDTH)];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.mas_bottom).with.offset(- PROGRESS_KWIDTH);
        make.width.height.mas_equalTo(PROGRESS_KWIDTH);
    }];
    self.progressView.userInteractionEnabled = YES;
    [self.progressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProgress)]];
    
    
}

- (void)clickProgress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickProgressView)]) {
        [self.delegate clickProgressView];
    }
}


#pragma  mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 20)];
    UIImageView *foldImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    foldImg.center = headerView.center;
    foldImg.image = [UIImage imageNamed:@"slide_icon"];
    foldImg.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:foldImg];
    headerView.userInteractionEnabled = YES;
    if (!headerView.gestureRecognizers.count) {
        [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFold)]];
    }
    return headerView;
    
}

- (void)clickFold {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFold)]) {
        [self.delegate clickFold];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100 - 20;
}



@end

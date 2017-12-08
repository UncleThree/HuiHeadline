//
//  HHVideoDetailBottomView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoDetailBottomView.h"
#import "HHHeadlineNewsBaseTableViewCell.h"
#import "HHHeadlineNewsLeftRightTableViewCell.h"
#import "HHAdAwardManager.h"

@interface HHVideoDetailBottomView ()<UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, strong)NSMutableArray<HHAdModel *> *adData;

@property (nonatomic, strong)HHAdModel *ad;

@property (nonatomic, assign)BOOL requesting;


@end

static NSString *identifier1 = @"VIDEO_AD_CELL1";
static NSString *identifier2 = @"VIDEO_AD_CELL2";
static NSString *identifier3 = @"VIDEO_AD_CELL3";

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
    [self.backTableView registerNib:[UINib nibWithNibName:@"HHHeadlineNewsLeftRightTableViewCell" bundle:nil] forCellReuseIdentifier:identifier1];
    
    
    
    
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

- (NSMutableArray<HHAdModel *> *)adData {
    if (!_adData) {
        _adData = [NSMutableArray array];
    }
    return _adData;
}

- (void)requstAds {
    
    NSLog(@"视频页广告请求");
    [HHHeadlineNetwork requestForAdList:^(NSError *error, id result) {
        
        if (error) {
            Log(error);
        } else {
            if (result && [result isKindOfClass:[NSArray class]]) {
                
                [self.adData addObjectsFromArray:result];
                if ([(NSArray *)result count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backTableView reloadData];
                    });
                }
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.requesting = NO;
        });
        
    }];
}

- (HHAdModel *)ad {
    
    if (!_ad) {
        if (self.adData.count) {
            _ad = self.adData[0];
            [self.adData removeObjectAtIndex:0];
        } else if (!self.requesting) {
            self.requesting = YES;
            [self requstAds];
        } else {
            
            
        }
    }
    return _ad;
}




#pragma  mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.ad = nil;

    HHHeadlineNewsLeftRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
    if (self.ad) {
        ListAdEncourageInfo *info = [[HHAdAwardManager sharedInstance] getEncourageInfoMap:self.ad.type];
        if (info && info.credit) {
            self.ad.AdAwards = [NSString stringWithFormat:@"+%zd金币", info.credit];
        } else {
            self.ad.AdAwards = nil;
        }
    }
    [cell setModel:self.ad];
    if (self.ad && self.delegate && [self.delegate respondsToSelector:@selector(exposure:)] && !self.ad.exporsed) {
        
        [self.delegate exposure:self.ad];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return VIDEO_AD_HEIGHT - 20;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (!self.ad) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAd:)]) {
        [self.delegate clickAd:self.ad];
    }
    
    
}




@end

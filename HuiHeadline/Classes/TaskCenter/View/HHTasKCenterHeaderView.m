//
//  HHTasKCenterHeaderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTasKCenterHeaderView.h"
#import "HHTaskCenterSignView.h"
#import "HHTaskCenterSignCollectionViewCell.h"
#import "HHTaskCollectionCellModel.h"


@interface HHTasKCenterHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)HHTaskCenterSignView *signView;

@property (nonatomic, strong)UIButton *howCreditButton;

@property (nonatomic, strong)UIView *line;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray<HHTaskCollectionCellModel *> *models;

@end


@implementation HHTasKCenterHeaderView


#define SIGN_WIDTH 100

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame response:nil];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                     response:(HHSignRecordResponse *)response {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame response:response];
    }
    return self;
    
}

- (void)initUI:(CGRect)frame
      response:(HHSignRecordResponse *)response{
    
    NSString *coin = response.signDailyRewards[response.day - 1];
    
    [self initSignViewWithState:response.state coin:coin];
    
    if (!G.$.bs) {
        [self initHowCreditButton];
    }

    [self initLineView];
    
    [self initModels:response];
    
    [self initCollectionView:frame];
    
    
    
}

- (void)initHowCreditButton {
    
    CGFloat height = 30;
    CGFloat width = CGFLOAT_W(95);
    self.howCreditButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.howCreditButton setTitle:@"如何赚钱" forState:(UIControlStateNormal)];
    self.howCreditButton.tintColor= [UIColor whiteColor];
    self.howCreditButton.titleLabel.font = Font(15);
    self.howCreditButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];
    [self addSubview:self.howCreditButton];
    self.howCreditButton.layer.cornerRadius = height / 2;
    
    [self.howCreditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signView).with.offset(16 + STATUSBAR_HEIGHT);
        make.right.equalTo(self).with.offset(10);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.howCreditButton addTarget:self action:@selector(howtoMakeMoney) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)howtoMakeMoney {
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskCenterHeaderViewClickHowToMakeMoney)]) {
        [self.delegate taskCenterHeaderViewClickHowToMakeMoney];
    }
    
}

- (void)initModels:(HHSignRecordResponse *)response {
    
    self.models = [NSMutableArray array];
    
    for (int i = 0; i < response.signDailyRewards.count; i++) {
        HHTaskCollectionCellModel *model = [[HHTaskCollectionCellModel alloc] init];
        model.coin = response.signDailyRewards[i];
        
        if (response.state) {
            
            if (i < response.day - 1 - 1) {
                model.type = HHTaskCollectionCellSigned;
                model.day = @"已领取";
            } else if (i == response.day - 1 - 1) {
                model.type = HHTaskCollectionCellSigned;
                model.day = @"今天";
            } else {
                model.type = HHTaskCollectionCellNormal;
                model.day = [NSString stringWithFormat:@"%zd天", i + 1];
            }
        } else {
            
            if (i < response.day - 1) {
                model.type = HHTaskCollectionCellSigned;
                model.day = @"已领取";
            } else if (i == response.day - 1) {
                model.type = HHTaskCollectionCellToday;
                model.day = @"今天";
            } else {
                model.type = HHTaskCollectionCellNormal;
                model.day = [NSString stringWithFormat:@"%zd天", i + 1];
            }
        }
        
        
        [self.models addObject:model];
    }
}

- (void)initSignViewWithState:(int)state
                         coin:(NSString *)coin{
    
    self.backgroundColor = RGB(230, 53, 40);
    CGFloat topPad = G.$.bs ? 10 : 30;
    self.signView = [[HHTaskCenterSignView alloc] initWithFrame:CGRectMake(KWIDTH / 2 - SIGN_WIDTH / 2, topPad + STATUSBAR_HEIGHT, SIGN_WIDTH, SIGN_WIDTH) state:state coin:coin];
    [self addSubview:self.signView];
    
    self.signView.userInteractionEnabled = YES;
    [self.signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sign)]];
}

- (void)sign {
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskCenterHeaderViewClickSign)]) {
        [self.delegate taskCenterHeaderViewClickSign];
    }
    
}

- (void)initLineView {
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.signView) + 7.5, KWIDTH, 1)];
    self.line.backgroundColor = RGB(202, 40, 27);
    [self addSubview:self.line];
}


- (void)initCollectionView:(CGRect)frame    {
    
    CGFloat collectionViewHeight = frame.size.height - MaxY(self.line);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake( (KWIDTH - 24 - (self.models.count - 1) * 5) / self.models.count - 1, collectionViewHeight - 15 * 2);
    
    
    CGFloat pad = 12;
    CGFloat topPad = 12;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(pad, MaxY(self.line) + topPad, KWIDTH - 2 * pad , collectionViewHeight - 2 * topPad) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[HHTaskCenterSignCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HHTaskCenterSignCollectionViewCell class])];

    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTaskCenterSignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHTaskCenterSignCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.item];
    return cell;
}



#pragma mark UICollectionViewDelegate



@end

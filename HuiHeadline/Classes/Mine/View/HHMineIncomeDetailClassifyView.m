//
//  HHMineIncomeDetailClassifyView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineIncomeDetailClassifyView.h"
#import "ClassifyCollectionViewCell.h"

@interface HHMineIncomeDetailClassifyView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong)NSMutableArray<ClassifyModel *> *models;


@end

@implementation HHMineIncomeDetailClassifyView


- (NSMutableArray<ClassifyModel *> *)models {
    
    if (!_models) {
        _models = [NSMutableArray array];
        NSArray *texts = @[@"全部",@"阅读收益",@"广告收益",@"邀请收益",@"活动收益"];
        for (int i = 0; i < 5; i++) {
            ClassifyModel *model = [ClassifyModel new];
            model.text = texts[i];
            model.select = (i == 0 ? YES : NO);
            [_models addObject:model];
        }
        
    }
    return _models;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}

- (void)initUI:(CGRect )frame {
    
    self.backgroundColor = [UIColor whiteColor];
    [self initCollectionView:frame];
    
    
}

- (void)initCollectionView:(CGRect)frame {
    
    self.collectionView = ({
        CGFloat pad = 15;
        CGFloat collectionviewHeight = frame.size.height - 2 * pad;
        self.collectionViewFlowLayout = [self getCollectionViewFlowLayout:frame];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(pad, pad, KWIDTH - pad * 2, collectionviewHeight) collectionViewLayout:self.collectionViewFlowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[ClassifyCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ClassifyCollectionViewCell class])];

        collectionView;
        
    });
   [self addSubview:self.collectionView];
    
}
- (UICollectionViewFlowLayout *)getCollectionViewFlowLayout:(CGRect)frame {
    if (!_collectionViewFlowLayout) {
        
        _collectionViewFlowLayout = ({
            UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            collectionViewFlowLayout.minimumLineSpacing = 20;
            collectionViewFlowLayout.minimumInteritemSpacing = 20;
            CGFloat pad =  15;
            collectionViewFlowLayout.itemSize = CGSizeMake( (KWIDTH - pad * 2 - 2 * 20)  / 3.0 - 1 , (frame.size.height - pad * 2 - 20 ) / 2 - 1);
//            collectionViewFlowLayout.headerReferenceSize = CGSizeMake(KWIDTH, 30);
            collectionViewFlowLayout;
            
        });
    }
    return _collectionViewFlowLayout;
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ClassifyCollectionViewCell class]) forIndexPath:indexPath];
    [cell setModel:self.models[indexPath.item]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (ClassifyModel *model in self.models) {
        [model setSelect:NO];
    }
    [self.models[indexPath.item] setSelect:YES];
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItem:)]) {
        
        [self.delegate selectItem:[self.models[indexPath.item] text]];
    }
}


@end

//
//  HHHeadlineShareCollectionView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineShareCollectionView.h"
#import "HHHeadlineShareCell.h"
#import "CollectionReusableView.h"


@interface HHHeadlineShareCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong)NSMutableArray<NSArray *> *data;

@end


@implementation HHHeadlineShareCollectionView

static NSString *reuseIdentifier = @"HHHeadlineShareCell";
static NSString *reuseHeaderIdentifier = @"HHNORMALHEADER";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame collectionViewLayout:self.collectionViewFlowLayout]) {
        [self initUI];
    }
    return self;
    
    
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[HHHeadlineShareCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
}



- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray array];
        [_data addObject:@[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"短信",@"复制链接",@"更多分享",]];
        [_data addObject:@[@"icon_weixinhaoyou",@"icon_weixinpengyouquan",@"icon_qqhaoyou",@"icon_qqkongjian",@"icon_duanxin",@"icon_fuzhilianjie",@"icon_moreShare"]];
    }
    return _data;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = ({
            UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            collectionViewFlowLayout.minimumLineSpacing = 20;
            collectionViewFlowLayout.minimumInteritemSpacing = 0;
            collectionViewFlowLayout.itemSize = CGSizeMake(KWIDTH  / 4.0 - 1 , 60.0);
            collectionViewFlowLayout.headerReferenceSize = CGSizeMake(KWIDTH, 30);
            collectionViewFlowLayout;
            
        });
    }
    return _collectionViewFlowLayout;
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data[0].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HHHeadlineShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setText:self.data[0][indexPath.item]];
    [cell setImgName:self.data[1][indexPath.item]];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    return  header;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(10, 0, 0, 0);
}


#pragma mark UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(collectionView:didDeselectItemText:)]) {
        
        [self.clickDelegate collectionView:collectionView didDeselectItemText:self.data[0][indexPath.item]];
        
    }
    
}




@end

//
//  HHHeadlineListShareViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListShareViewController.h"
#import "HHHeadlineShareCell.h"
#import "CollectionReusableView.h"

@interface HHHeadlineListShareViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong)NSMutableArray<NSArray *> *data;

@end

@implementation HHHeadlineListShareViewController

static NSString *reuseIdentifier = @"HHHeadlineShareCell";
static NSString *reuseHeaderIdentifier = @"HHNORMALHEADER";

    

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TRAN_BLACK;
    [self initCollectionView];
}


- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray array];
        [_data addObject:@[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"短信",@"复制链接",@"更多分享",]];
        [_data addObject:@[@"icon_weixinhaoyou",@"icon_weixinpengyouquan",@"icon_qqhaoyou",@"icon_qqkongjian",@"icon_duanxin",@"icon_fuzhilianjie",@"icon_moreShare"]];
    }
    return _data;
}

- (void)initCollectionView {
    self.collectionView = ({
        CGFloat collectionviewHeight = 200;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KHEIGHT - collectionviewHeight, KWIDTH, collectionviewHeight) collectionViewLayout:self.collectionViewFlowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[HHHeadlineShareCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
        collectionView;
        
    });
    [self.view addSubview:self.collectionView];
    
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





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"分享到 %@",self.data[0][indexPath.item]);
    
}





@end

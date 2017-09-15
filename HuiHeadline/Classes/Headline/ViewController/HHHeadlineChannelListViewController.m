//
//  HHHeadlineChannelListViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/14.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineChannelListViewController.h"
#import "BMTodayHeadlinesDragCell.h"

@interface HHHeadlineChannelListViewController ()



@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;


@end

@implementation HHHeadlineChannelListViewController



- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = ({
            UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            collectionViewFlowLayout.minimumLineSpacing = 0;
            collectionViewFlowLayout.minimumInteritemSpacing = 0;
            collectionViewFlowLayout.itemSize = CGSizeMake(KWIDTH  / 4.0 - 10 , 55.0);
            collectionViewFlowLayout.headerReferenceSize = CGSizeMake(100, 40);
            collectionViewFlowLayout;
            
        });
    }
    return _collectionViewFlowLayout;
}

- (NSMutableArray<NSMutableArray<NSString *> *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
        //用一个manager管理channels
        NSMutableArray *myChannel = @[@"头条",@"社会",@"国内",@"健康",@"国际",@"人文",@"娱乐",@"科技",@"军事", @"时尚", @"游戏", @"汽车"].mutableCopy;
        NSMutableArray *otherChannel = @[@"财经",@"搞笑", @"体育",@"星座",@"科学", @"互联网",@"数码",@"电视"].mutableCopy;
        [_dataSourceArray addObject:myChannel];
        [_dataSourceArray addObject:otherChannel];
        
    }
    return _dataSourceArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self initDragCollctionView];
    
}


- (void)initNavigation {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
}

- (void)goBack {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)initDragCollctionView {
    
    self.showDeleteButton = NO;
    self.dragCollectionView = ({
        BMDragCellCollectionView *collectionView = [[BMDragCellCollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:self.collectionViewFlowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = (id)self;
        collectionView.delegate = (id)self;
        
        [collectionView registerNib:[UINib nibWithNibName:@"BMTodayHeadlinesDragCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HHHeadlineChannelListHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HHHeadlineChannelListSecondHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSecoundHeaderIdentifier];
        
        collectionView;
    });
    [self.view addSubview:self.dragCollectionView];
    
}





@end

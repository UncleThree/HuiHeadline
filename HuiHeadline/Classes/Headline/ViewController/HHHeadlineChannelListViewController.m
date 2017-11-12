//
//  HHHeadlineChannelListViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/14.
//  Copyright © 2017年 eyuxin. All rights reserved.

#import "HHHeadlineChannelListViewController.h"
#import "BMTodayHeadlinesDragCell.h"
#import "HHHeadlineChannelListViewController+Delegate.h"

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
            collectionViewFlowLayout.itemSize = CGSizeMake(KWIDTH  / 4.0 - 1 , 55.0);
            collectionViewFlowLayout.headerReferenceSize = CGSizeMake(100, 40);
            collectionViewFlowLayout;
            
        });
    }
    return _collectionViewFlowLayout;
}

- (NSMutableArray<NSMutableArray<NSString *> *> *)dataSourceArray {
    
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNavigation];
    [self initDragCollctionView];
    
   
}




- (void)initNavigation {
    
        
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回(3)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backItem.tintColor = BLACK_153;
    
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithTitle:@"频道列表" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    labelItem.tintColor = BLACK_51;
    [labelItem setTitleTextAttributes:@{NSFontAttributeName:Font(20)} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItems = @[backItem,labelItem];
    
    
}

- (void)goBack {
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            view.hidden = NO;
        }
    }
    [HHUserManager sharedInstance].channels = self.dataSourceArray[0].mutableCopy;
    [self.navigationController popViewControllerAnimated:YES];
    self.block([HHUserManager sharedInstance].channels);

}

- (void)initDragCollctionView {
    
    self.showDeleteButton = NO;
    self.dragCollectionView = ({
        BMDragCellCollectionView *collectionView = [[BMDragCellCollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:self.collectionViewFlowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerNib:[UINib nibWithNibName:@"BMTodayHeadlinesDragCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HHHeadlineChannelListHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
        
        [collectionView registerClass:NSClassFromString(@"HHHeadlineChannelListSecondHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSecoundHeaderIdentifier];

        
        collectionView;
    });
    [self.view addSubview:self.dragCollectionView];
    
}





@end

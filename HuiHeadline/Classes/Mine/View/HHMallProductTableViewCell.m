//
//  HHMallProductTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMallProductTableViewCell.h"

@interface HHMallProductTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionViewFlowLayout *layout;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray<HHMallProductCollectionViewCellModel *> *models;

@end


@implementation HHMallProductTableViewCell

#define HEIGHT 100.0

- (void)setProducts:(NSMutableArray<HHProductOutline *> *)products {
    
    _products = products;
    self.models = [NSMutableArray array];
    for (int i = 0 ; i < products.count; i++) {
        HHProductOutline *product = products[i];
        HHMallProductCollectionViewCellModel *model = [HHMallProductCollectionViewCellModel new];
        model.selected = i == 0;
        model.coins = [NSString stringWithFormat:@"%zd.00元",product.originalPrice / 100];
        model.leftNum = [NSString stringWithFormat:@"剩余%@件", [HHUtils insertComma:[NSString stringWithFormat:@"%zd",product.leftNum]]];
        [self.models addObject:model];
    }
    if (H(self.contentView) > 0) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.equalTo(self.contentView).with.offset(20);
            make.right.and.bottom.equalTo(self.contentView).with.offset(-20);
        }];
    }
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake((KWIDTH - 20 * 2 - 41)  / 3.0, HEIGHT);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[HHMallProductCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HHMallProductCollectionViewCell class])];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMallProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHMallProductCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i < self.models.count; i++) {
        [self.models[i] setSelected:NO];
    }
    [self.models[indexPath.item] setSelected:YES];
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectProductItem:)]) {
        [self.delegate selectProductItem:self.products[indexPath.item]];
    }
    
    
}


@end


@implementation HHMallProductCollectionViewCellModel




@end


@interface HHMallProductCollectionViewCell ()

@property (nonatomic, strong)UILabel *creditLabel;

@property (nonatomic, strong)UILabel *leftLabel;

@end

@implementation HHMallProductCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
    
}

- (void)initUI:(CGRect)frame    {
    
    self.creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
    self.creditLabel.textAlignment = 1;
    self.creditLabel.layer.cornerRadius = 5;
    self.creditLabel.layer.masksToBounds = YES;
    [self addSubview:self.creditLabel];

    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.creditLabel) + 4, frame.size.width, 15)];
    self.leftLabel.font = Font(12);
    self.leftLabel.textColor = BLACK_51;
    [self addSubview:self.leftLabel];

    
}

- (void)setModel:(HHMallProductCollectionViewCellModel *)model {
    
    _model = model;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.coins attributes:@{KEY_FONT:Font(22)}];
    [attStr addAttribute:KEY_FONT value:Font(13) range:NSMakeRange(model.coins.length - 1, 1)];
    self.creditLabel.attributedText = attStr.copy;
    self.leftLabel.text = model.leftNum;
    if (model.selected) {
        self.creditLabel.backgroundColor = RGB(255, 235, 235);
        self.creditLabel.textColor = HUIRED;
    } else {
        self.creditLabel.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.creditLabel.textColor = BLACK_51;
    }
    
}



@end




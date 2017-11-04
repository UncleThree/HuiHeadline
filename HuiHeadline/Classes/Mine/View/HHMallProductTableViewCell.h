//
//  HHMallProductTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHMallProductCollectionViewCellModel : NSObject

@property (nonatomic, strong)NSString *coins;

@property (nonatomic, strong)NSString *leftNum;

@property (nonatomic, assign)BOOL selected;

@end


@interface HHMallProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)HHMallProductCollectionViewCellModel *model;

@end

@protocol HHMallProductTableViewCellDelegate <NSObject>

- (void)selectProductItem:(HHProductOutline *)products;

@end

@interface HHMallProductTableViewCell : UITableViewCell

@property (nonatomic, weak)id <HHMallProductTableViewCellDelegate> delegate;

@property (nonatomic, strong)NSArray <HHProductOutline *> *products;

@end



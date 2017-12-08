//
//  ClassifyCollectionViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyModel : NSObject

@property (nonatomic, strong)NSString *text;

@property (nonatomic, assign)BOOL select;

@end

@interface ClassifyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ClassifyModel *model;

@end

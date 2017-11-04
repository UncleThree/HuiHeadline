//
//  HHHeadlineShareCollectionView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HHHeadlineShareCollectionViewDelegate <NSObject>

@required

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemText:(NSString *)text;


@end

@interface HHHeadlineShareCollectionView : UICollectionView

@property (nonatomic, assign)id <HHHeadlineShareCollectionViewDelegate> clickDelegate;


@end

//
//  HHMallProductPurchaseView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHProductIndoResponse.h"

@protocol HHMallPurchaseViewDelegate <NSObject>

- (void)mallpurchaseViewPurchase:(HHProductOutline *)product;

@end

@interface HHMallProductPurchaseView : UIView

@property (nonatomic, weak)id <HHMallPurchaseViewDelegate>delegate;

///当前选中的product
@property (nonatomic, strong)HHProductOutline *product;

- (instancetype)initWithFrame:(CGRect)frame ;

@end

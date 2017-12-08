//
//  HHMineIncomeDetailClassifyView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassifyDelegate<NSObject>

- (void)selectItem:(NSString *)item;

@end

@interface HHMineIncomeDetailClassifyView : UIView

@property (nonatomic, weak)id<ClassifyDelegate> delegate;

@end

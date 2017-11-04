//
//  HHMineUpdateGenderView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHMineUpdateGenderViewDelegate <NSObject>

- (void)selectGender:(NSString *)gender;

@end

@interface HHMineUpdateGenderModel : NSObject

@property (nonatomic, copy)NSString *text;

@property (nonatomic, assign)BOOL select;

@end

@interface HHMineUpdateGenderView : UIView

@property (nonatomic, weak)id<HHMineUpdateGenderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
                       gender:(NSString *)gender;

@end


@interface HHMineUpdateGenderTableViewCell : UITableViewCell

@property (nonatomic, strong)HHMineUpdateGenderModel *model;


@end



//
//  HHMineTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHMineTableViewCellDelgate <NSObject>

- (void)HHMineTableViewCellDidClickButtonText:(NSString *)text;

@end


@interface HHMineTableViewCell : UITableViewCell

@property (nonatomic,weak)id <HHMineTableViewCellDelgate>delegate;

@end

@interface HHMineImageAndLabelView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                         text:(NSString *)text
                    plumAward:(BOOL)plumAward;

@end


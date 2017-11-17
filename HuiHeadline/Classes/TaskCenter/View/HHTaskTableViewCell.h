//
//  HHTaskTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTaskCellModel.h"

@protocol HHTaskCellModelDelegate <NSObject>

- (void)activityTaskTitle:(NSString *)title
                      url:(NSString *)url;

- (void)taskTableViewCellDidClickTaskId:(NSInteger)taskId
                               isNewbie:(BOOL)isNewbie
                                  title:(NSString *)title
                                    url:(NSString *)url;

@end

@interface HHTaskTableViewCell : UITableViewCell

@property (nonatomic, weak)id <HHTaskCellModelDelegate>delegate;

@property (nonatomic ,strong)HHTaskCellModel *model;

@end

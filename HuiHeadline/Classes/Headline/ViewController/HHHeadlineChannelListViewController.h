//
//  HHHeadlineChannelListViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/14.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *reuseIdentifier = @"BMTodayHeadlines";

static NSString *reuseHeaderIdentifier = @"BMHeaderIdentifier";

static NSString *reuseSecoundHeaderIdentifier = @"BMSecoundHeaderIdentifier";


@interface HHHeadlineChannelListViewController : UIViewController

@property (nonatomic, copy)void(^block)(NSArray *channels);

@property (strong, nonatomic) NSMutableArray <NSMutableArray <NSString *>*>*dataSourceArray;
@property (nonatomic, strong)BMDragCellCollectionView *dragCollectionView;
//是否显示删除按钮
@property (nonatomic) BOOL showDeleteButton;

@end

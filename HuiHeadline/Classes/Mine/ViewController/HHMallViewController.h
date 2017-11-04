//
//  HHMallViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHMallTableViewDelegate <NSObject>

- (void)clickSetAccountCellCategory:(NSInteger)category;


@end

@interface HHMallViewController : UIViewController

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, weak)id <HHMallTableViewDelegate> delegate;

@property (nonatomic, assign)NSInteger category;

@end

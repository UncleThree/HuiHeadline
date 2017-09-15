//
//  HHHeadlineSegmentViewController+TableView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/14.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineSegmentViewController+TableView.h"
#import "HHHeadlineDetaiklViewController.h"
#import "HHHeadlineChannelListViewController.h"

@implementation HHHeadlineSegmentViewController (TableView)

#pragma mark WMPageControllerDataSource



- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return [self itemNames][index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HHHeadlineDetaiklViewController *detailVC = [[HHHeadlineDetaiklViewController alloc] init];
    detailVC.type = self.itemNames[index];
    return detailVC;
}

#pragma mark WMAddButtonDelegate

- (void)didClickAddButton {
    
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[HHHeadlineChannelListViewController alloc] init]] animated:NO completion:^{
        
    }];
    
}


@end

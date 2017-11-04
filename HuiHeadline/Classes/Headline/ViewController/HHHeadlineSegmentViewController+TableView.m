//
//  HHHeadlineSegmentViewController+TableView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/14.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineSegmentViewController+TableView.h"
#import "HHHeadlineListViewController.h"
#import "HHHeadlineChannelListViewController.h"

@implementation HHHeadlineSegmentViewController (TableView)

#pragma mark WMPageControllerDataSource



- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return [self itemNames][index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HHHeadlineListViewController *detailVC = [[HHHeadlineListViewController alloc] init];
    detailVC.type = self.itemNames[index];
    return detailVC;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    
    return [HHFontManager sizeWithText:self.itemNames[index] font:[UIFont systemFontOfSize:19] maxSize:CGSizeMake(CGFLOAT_MAX, 44)].width;
    
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    
    return 12;
}



@end

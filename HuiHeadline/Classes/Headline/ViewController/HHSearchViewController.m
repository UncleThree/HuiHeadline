//
//  HHSearchViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/12/1.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHSearchViewController.h"

@interface HHSearchViewController ()<PYSearchViewControllerDataSource, PYSearchViewControllerDelegate>

@end



@implementation HHSearchViewController

static HHSearchViewController *searchVC = nil;


+ (id)defaultVC {
    
    NSString *place = @"搜索你感兴趣的内容";
    searchVC = [HHSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:place didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];
    searchVC.hotSearchStyle = PYHotSearchStyleRankTag;
    searchVC.searchHistoryStyle = PYSearchHistoryStyleCell;
    
//    searchVC.dataSource = searchVC;
    searchVC.searchHistoryTitle = @"历史搜索";
    searchVC.delegate = searchVC;
    [self requestHots];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    return nav;
}


+ (void)requestHots {
    
    [HHHeadlineNetwork requestHotSearch:^(id error, NSArray<HHHotRecommend *> *hots) {
        if (hots && hots.count) {
            
            [self setHotSearches:hots maxCount:8];
        }
    }];
}

+ (void)setHotSearches:(NSArray<HHHotRecommend *> *)hots
              maxCount:(NSInteger)maxCount {
    NSMutableArray *hotSearches = [NSMutableArray array];
    for (int i = 0 ; i < hots.count ;i ++) {
        if (i == maxCount) {
            break;
        }
        [hotSearches addObject:[hots[i] words]];
    }
    searchVC.hotSearches = hotSearches.copy;
    
}




@end

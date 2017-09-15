//
//  HHHeadlineSegmentViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineSegmentViewController.h"
#import "HHHeadlineDetaiklViewController.h"
#import "HHHeadlineNavController.h"
#import "HHHeadlineChannelListViewController.h"


@interface HHHeadlineSegmentViewController () 



@end

@implementation HHHeadlineSegmentViewController

static HHHeadlineSegmentViewController *vc = nil;


+ (UINavigationController *)defaultSegmentVC {
    static HHHeadlineNavController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        HHHeadlineSegmentViewController *vc = [[HHHeadlineSegmentViewController alloc] initWithViewControllerClasses:[self viewControllerClasses] andTheirTitles:[self itemNames]];
        vc = [[HHHeadlineSegmentViewController alloc] init];
//        vc.keys = [self vcKeys].mutableCopy;
//        vc.values = [self vcValues].mutableCopy;
        navi = [[HHHeadlineNavController alloc] initWithRootViewController:vc];
        vc.dataSource = vc;
        vc.addDelegate = (id)vc;
        vc.itemNames = [NSMutableArray arrayWithArray:@[@"头条",@"社会",@"国内",@"国际",@"娱乐",@"科技",@"军事"]];
       
    });
    return navi;
}

- (NSArray *)viewControllerClasses {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:[HHHeadlineDetaiklViewController class]];
    }
    
    return [mArr copy];
}

- (NSArray *)vcKeys {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:@"infoType"];
    }
    return [mArr copy];
}

- (NSArray *)vcValues {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:@(i)];
    }
    return [mArr copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        vc.itemNames[0] = @"头条" ;
        [vc reloadData];
    });
}








@end

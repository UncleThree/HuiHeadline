//
//  HHHeadlineSegmentViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineSegmentViewController.h"
#import "HHHeadlineListViewController.h"
#import "HHHeadlineChannelListViewController.h"


@interface HHHeadlineSegmentViewController () <WMAddButtonDelegate>



@end

@implementation HHHeadlineSegmentViewController

static HHHeadlineSegmentViewController *vc = nil;


+ (HHHeadlineNavController *)defaultSegmentVC {
    static HHHeadlineNavController *navi = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        vc = [[HHHeadlineSegmentViewController alloc] init];
        vc.dataSource = vc;
        vc.addDelegate = (id)vc;
        navi = [[HHHeadlineNavController alloc] initWithRootViewController:vc];
//    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadSegment];
    
    
}

- (void)addBackView {
    
    for (int i = 0; i < vc.itemNames.count; i++) {
        
        CGFloat width = KWIDTH / 3;
        CGFloat height = width * 200 / 369;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH * i + width , 0, width, height)];
        imgV.image = [UIImage imageNamed:@"才是头条"];
        imgV.center = CGPointMake(imgV.center.x, vc.scrollView.center.y - CGFLOAT(60));
        [vc.scrollView insertSubview:imgV atIndex:0];
    }
}

- (void)reloadSegment {
    
    vc.itemNames = HHUserManager.sharedInstance.channels;
    [vc reloadData];
    [self addBackView];
    
}


- (NSArray *)viewControllerClasses {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:[HHHeadlineListViewController class]];
    }
    
    return [mArr copy];
}



#pragma mark WMAddButtonDelegate

- (void)didClickAddButton {
    
    self.hidesBottomBarWhenPushed = YES;
    HHHeadlineChannelListViewController *channelListVC = [HHHeadlineChannelListViewController new];
    [channelListVC setDataSourceArray:[self setChannelListData]];
    channelListVC.block = ^(NSArray *channels) {
        
        if (![channels isEqualToArray:vc.itemNames.copy]) {
            
            HHUserManager.sharedInstance.channels = channels.mutableCopy;
            [self reloadSegment];
        } else {
            //do noting
        }
    };
    [self.navigationController pushViewController:channelListVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [[(HHHeadlineNavController *)self.navigationController timeLabel] setHidden:YES];
    [[(HHHeadlineNavController *)self.navigationController alarmImgv] setHidden:YES];
    [[(HHHeadlineNavController *)self.navigationController titleImgV] setHidden:YES];
    
}

- (NSMutableArray *)setChannelListData {
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    NSMutableArray *myChannel = [HHUserManager sharedInstance].channels.mutableCopy;
    NSMutableArray *otherChannel = [self getOtherChannels].mutableCopy;
    [dataSourceArr addObject:myChannel];
    [dataSourceArr addObject:otherChannel];
    return dataSourceArr;
}

- (NSMutableArray *)getOtherChannels {
    
    NSMutableArray *other = [NSMutableArray arrayWithArray:HHUserManager.sharedInstance.allChannels.copy];
    for (NSString *channle in [HHUserManager sharedInstance].channels) {
        [other removeObject:channle];
    }
    return other;
    
}








@end

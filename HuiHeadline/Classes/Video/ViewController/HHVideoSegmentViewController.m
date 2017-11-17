//
//  HHVideoSegmentViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoSegmentViewController.h"
#import "HHVideoListWebViewController.h"
#import "HHHeadlineChannelListViewController.h"

@interface HHVideoSegmentViewController ()<WMPageControllerDataSource, WMAddButtonDelegate>



@end

static HHVideoSegmentViewController *videoSegmentVC = nil;

@implementation HHVideoSegmentViewController

+ (UINavigationController *)defaultSegmentVC {
    
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoSegmentVC = [[HHVideoSegmentViewController alloc] init];
        videoSegmentVC.dataSource = videoSegmentVC;
        videoSegmentVC.addDelegate = videoSegmentVC;
        navi = [[UINavigationController alloc] initWithRootViewController:videoSegmentVC];
        
    });
    return navi;
}



- (NSArray *)viewControllerClasses {
    NSMutableArray *mArr = [NSMutableArray new];
    for (int i = 0; i < [self itemNames].count; i++) {
        [mArr addObject:[HHVideoListWebViewController class]];
    }
    return [mArr copy];
}



- (NSMutableArray *)itemNames {
    
    return [HHUserManager sharedInstance].video_channels;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadSegment];

    
}


- (void)addBackView {
    
    for (int i = 0; i < videoSegmentVC.itemNames.count; i++) {
        
        CGFloat width = KWIDTH / 3;
        CGFloat height = width * 200 / 369;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH * i + width , 0, width, height)];
        imgV.image = [UIImage imageNamed:@"才是头条"];
        imgV.center = CGPointMake(imgV.center.x, videoSegmentVC.scrollView.center.y - CGFLOAT(60));
        [videoSegmentVC.scrollView insertSubview:imgV atIndex:0];
    }
}


#pragma mark WMPageDataSource+AddButton

- (void)reloadSegment {
    
    videoSegmentVC.itemNames = HHUserManager.sharedInstance.video_channels;
    [videoSegmentVC reloadData];
    [self addBackView];
    
}

- (void)didClickAddButton {
    //显示navigation
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    HHHeadlineChannelListViewController *channelListVC = [HHHeadlineChannelListViewController new];
    [channelListVC setDataSourceArray:[self setChannelListData]];
    channelListVC.block = ^(NSArray *channels) {
        
        if (![channels isEqualToArray:videoSegmentVC.itemNames.copy]) {
            [HHUserManager sharedInstance].video_channels = channels.mutableCopy;
            [self reloadSegment];
        }
    };
    [self.navigationController pushViewController:channelListVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
}





- (NSMutableArray *)setChannelListData {
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    NSMutableArray *myChannel = [HHUserManager sharedInstance].video_channels.mutableCopy;
    NSMutableArray *otherChannel = [self getOtherChannels].mutableCopy;
    [dataSourceArr addObject:myChannel];
    [dataSourceArr addObject:otherChannel];
    return dataSourceArr;
}

- (NSMutableArray *)getOtherChannels {
    NSMutableArray *other = [NSMutableArray arrayWithArray:HHUserManager.sharedInstance.vodeo_allChannels.copy];
    for (NSString *channle in [HHUserManager sharedInstance].video_channels) {
        [other removeObject:channle];
    }
    return other;
    
}

- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index {
    
    return self.itemNames[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HHVideoListWebViewController *detailVC = [[HHVideoListWebViewController alloc] init];
    NSString *channelId = [NSString stringWithFormat:@"%@",[k_video_channelDict objectForKey:self.itemNames[index]]];
    NSString *url = [k_video_baseurl stringByAppendingString:channelId];
    detailVC.URLString = url;
    return detailVC;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    return CGRectMake(0, 30, self.view.frame.size.width - segmentHeight, segmentHeight);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    
    return [HHFontManager sizeWithText:self.itemNames[index] font:[UIFont systemFontOfSize:19] maxSize:CGSizeMake(CGFLOAT_MAX, 44)].width;
    
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    
    return 12;
}



@end

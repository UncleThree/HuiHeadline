//
//  HHHeadlineSegmentViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <WMPageController/WMPageController.h>

@interface HHHeadlineSegmentViewController : WMPageController

+ (UINavigationController *)defaultSegmentVC;

@property (nonatomic, strong)NSMutableArray *itemNames;

@end

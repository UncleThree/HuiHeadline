//
//  HHHeadlineSegmentViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "HHHeadlineNavController.h"

@interface HHHeadlineSegmentViewController : WMPageController

+ (HHHeadlineNavController *)defaultSegmentVC;

@property (nonatomic, strong)NSMutableArray *itemNames;

- (void)reloadSegment ;

@end

//
//  AppDelegate.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    InstallTypeFirst = 0,
    InstallTypeUpdate = 1,
    InstallTypeNormal = 2,
    
} InstallType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)firstAward;
- (BOOL)firstLoad;
- (BOOL)firstVideo;
- (InstallType)isFirstLoadOrUpdate;
- (BOOL)firstShareCircle;

@end


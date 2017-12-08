//
//  FMDeviceManager.h
//  FMDeviceManager
//
//  Copyright (c) 2016年 Tongdun.inc. All rights reserved.
//

#define FM_SDK_VERSION @"3.0.8"

#import <Foundation/Foundation.h>

typedef struct _void {
    void (*initWithOptions)(NSDictionary *);
    NSString *(*getDeviceInfo)();
    NSString *(*getInitStatus)();
} FMDeviceManager_t;

@interface FMDeviceManager : NSObject

+ (FMDeviceManager_t *) sharedManager;
+ (void) destroy;

@end


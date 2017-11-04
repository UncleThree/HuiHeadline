//
//  HHUtils.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAdRequest.h"

@interface HHDeviceUtils : NSObject

+ (DeviceId *)getDeviceID ;
+ (Device *)getDevice;
+ (Gps *)getGps;
+ (Network *)getNetwork;



@end

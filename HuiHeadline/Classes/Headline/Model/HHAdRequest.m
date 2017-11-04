//
//  HHAdRequest.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHAdRequest.h"
#import "HHDeviceUtils.h"

@implementation HHAdRequest

- (instancetype)init {
    
    if (self = [super init]) {
        _device = [HHDeviceUtils getDevice];
        _deviceId = [HHDeviceUtils getDeviceID];
        _gps = [HHDeviceUtils getGps];
        _network = [HHDeviceUtils getNetwork];
    }
    return self;
}

@end

@implementation DeviceId

@end

@implementation Device

@end

@implementation Network

@end

@implementation Gps

@end




//
//  HHUtils.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHDeviceUtils.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#import "sys/utsname.h"

@implementation HHDeviceUtils



+ (DeviceId *)getDeviceID {
    
    DeviceId *deviceId = [[DeviceId alloc] init];
    deviceId.did = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
    deviceId.mac = @"020000000";
    deviceId.pid = nil;
    deviceId.imsi = nil;
    return deviceId;
    
}

+ (Device *)getDevice {
    Device *device = [[Device alloc] init];
    device.deviceType = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2 : 1;
    device.vendor = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    device.model = [self deviceVersion];
    device.os = 2;
    device.osVersion = [UIDevice currentDevice].systemVersion;
    device.width = KWIDTH;
    device.height = KHEIGHT;
    device.dpi = 0.0f; //
    return device;
}

+ (NSString*)deviceVersion
{

    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

+ (Gps *)getGps {
    Gps *gps = [[Gps alloc] init];
//    gps.longitude = 1;
//    gps.latitude = 2;
    gps.timestamp = (int)[[NSDate date] timeIntervalSince1970];// *1000后获得毫秒
    return gps;
    
}

+ (Network *)getNetwork {
    Network *network = [[Network alloc] init];
    network.connectionType = [self formatConnectionType];//0. 未知 1. WIFI 2. 2G 3. 3G 4. 4G 5. 其他
    network.operatorType = [self getOperator]; // 0. 未知 1. 中国移动 2. 中国电信 3. 中国联通 4. 其他
    return network;
}


+ (int)formatConnectionType {
    Reachability *rea = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [rea currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            return 0;
        case ReachableViaWiFi:
            return 1;
        case kReachableVia2G:
            return 2;
        case kReachableVia3G:
            return 3;
        case kReachableVia4G:
            return 4;
    }
    return 0;
    
}

+ (int)getOperator {
   
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        
        mobile = @"无运营商";
        return 0;
        
    }else{
        mobile = [carrier carrierName];
        if ([mobile isEqualToString:@"中国移动"]) {
            return 1;
        } else if ([mobile isEqualToString:@"中国电信"]) {
            return 2;
        } else if ([mobile isEqualToString:@"中国联通"]) {
            return 3;
        } else {
            return 4;
        }
    }
   
}

@end

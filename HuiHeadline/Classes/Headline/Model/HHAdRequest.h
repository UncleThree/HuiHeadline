//
//  HHAdRequest.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHAdStrategy.h"

@class DeviceId;
@class Device;
@class Gps;
@class Network;
@class AdPosition;



@interface DeviceId : NSObject

@property (nonatomic, copy)NSString *did;// android imei，苹果idfa 广告标识符
@property (nonatomic, copy)NSString *mac;//mac地址 iOS7之后不推荐使用 返回固定值
@property (nonatomic, copy)NSString *pid;
@property (nonatomic, copy)NSString *imsi;//手机串号
//经过调研，代码实现获取iPhone手机串号是获取不到的，网上提供的一些获取手机串号都是通过第三方库来写的，使用这些库的app在app store是审核不了的，所以目前还没有办法获取手机串号imsi的。

@end

@interface Device : NSObject

@property (nonatomic)int deviceType;// 1. 手机 2. 平板
@property (nonatomic, copy)NSString *vendor;
@property (nonatomic, copy)NSString *model;
@property (nonatomic)int os;// 1. Android 2. iOS
@property (nonatomic, copy)NSString *osVersion; //like 4.4.1
@property (nonatomic)int width;
@property (nonatomic)int height;
///屏幕分辨率
@property (nonatomic)float dpi;


@end

@interface Gps : NSObject

@property (nonatomic)double longitude;
@property (nonatomic)double latitude;
@property (nonatomic)int timestamp;

@end

@interface Network : NSObject

@property (nonatomic)int connectionType; // 0. 未知 1. WIFI 2. 2G 3. 3G 4. 4G 5. 其他
@property (nonatomic)int operatorType; // 0. 未知 1. 中国移动 2. 中国电信 3. 中国联通 4. 其他

@end



@interface HHAdRequest : NSObject

@property (nonatomic,copy)NSString *appVersion;
@property (nonatomic,strong)DeviceId *deviceId;
@property (nonatomic,strong)Device *device;
@property (nonatomic,strong)Gps *gps;
@property (nonatomic,strong)Network *network;
@property (nonatomic,copy)NSString *planId;
@property (nonatomic,strong)AdPosition *adPosition;


@end



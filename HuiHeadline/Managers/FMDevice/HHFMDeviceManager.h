//
//  FMDeviceManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/12/4.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * FMEvent = @"Browse";
static NSString * FMEvent_click = @"Click";

static NSString * FMType = @"Browse";
static NSString * FMType_click = @"click";

@interface FMRequest : NSObject

@property (nonatomic, strong)NSString *blackbox;

@property (nonatomic, assign)NSInteger readSeconds;

@property (nonatomic, assign)NSInteger touch;
///0 android 1 ios
@property (nonatomic, assign)short platform;

@property (nonatomic, strong)NSString *userId;
///huitoutiao
@property (nonatomic, strong)NSString *channel;

///Click / Browse 或者Browse / Click

@property (nonatomic, strong)NSString *event;
/// idfa或者IMEI
@property (nonatomic, strong)NSString *deviceId;
/// browse/click
@property (nonatomic, strong)NSString *type;
///将新闻Url进行md5加密后的ID
@property (nonatomic, strong)NSString *newsId;

@property (nonatomic, strong)NSString *phone;

- (instancetype)initWithEvent:(NSString *)event
                         type:(NSString *)type
                       newsId:(NSString *)newsId
                  readSeconds:(NSInteger)readSeconds
                        touch:(NSInteger)touch;

@end

@interface FMActivateRequest : NSObject

@property (nonatomic, strong)NSString *channel;

@property (nonatomic, strong)NSString *deviceId;

@property (nonatomic, strong)NSString *blackBox;


@end

@interface HHFMDeviceManager : NSObject

///同盾 news action
+ (void)FMDeviceWithNewsUrl:(NSString *)url
                readSeconds:(NSInteger)readSeconds
                      touch:(NSInteger)touch
                   callback:(void(^)())callback;

+ (void)FMDeviceActivate;


@end

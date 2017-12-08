//
//  FMDeviceManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/12/4.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHFMDeviceManager.h"
#import "FMDeviceManager.h"
#import<CommonCrypto/CommonDigest.h>


@implementation FMActivateRequest

- (instancetype)init {
    
    if (self = [super init]) {
        
        _channel = [HHDeviceUtils appChannel];
        _deviceId = UUID;
        _blackBox = [FMDeviceManager sharedManager]->getDeviceInfo();
    }
    return self;
}

@end

@implementation FMRequest

- (instancetype)initWithEvent:(NSString *)event
                         type:(NSString *)type
                       newsId:(NSString *)newsId
                  readSeconds:(NSInteger)readSeconds
                        touch:(NSInteger)touch {
    
    if (self = [super init]) {
        
        _newsId = newsId;
        _readSeconds = readSeconds;
        _touch = touch;
        _blackbox = FMDeviceManager.sharedManager->getDeviceInfo();
        _platform = 1;
        _channel = @"huitoutiao";
        _deviceId = [HHDeviceUtils IDFA];
        if (!event) {
            _event = FMEvent;
        } else {
            _event = event;
        }
        if (!type) {
            _type = FMType;
        } else {
            _type = type;
        }
        
        _phone = HHUserManager.sharedInstance.currentUser.userInfo.phone;
        _userId = [NSString stringWithFormat:@"%ld",HHUserManager.sharedInstance.currentUser.userInfo.user_id];
        
        
    }
    return self;
}

@end

@implementation HHFMDeviceManager


+ (void)FMDeviceWithNewsUrl:(NSString *)url
                readSeconds:(NSInteger)readSeconds
                      touch:(NSInteger)touch
                   callback:(void(^)())callback
{
    
    NSLog(@"同盾新闻时间统计");
    FMRequest *request = [[FMRequest alloc] initWithEvent:nil type:nil newsId:[self md5:url] readSeconds:readSeconds touch:touch];
    NSDictionary *parameters = [request mj_JSONObject];
    NSLog(@"%@",parameters);
    
    [HHNetworkManager postRequestWithUrl:fm_news_action_url parameters:parameters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (callback) {
            callback();
        }
        
        if (error) {
            
            NSLog(@"同盾新闻事件%@",error);
            
        } else {
            
            NSLog(@"同盾新闻事件%@",respondsStr);
            
        }
        
    }];
    
    
}




+ (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr,  (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


+ (void)FMDeviceActivate {
    
    FMActivateRequest *request = [[FMActivateRequest alloc] init];
    NSDictionary *parameters = [request mj_JSONObject];
    [HHNetworkManager postRequestWithUrl:fm_news_activate_url parameters:parameters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
         
        if (error) {
            
            NSLog(@"同盾激活事件%@",error);
            
        } else {
            
            NSLog(@"同盾激活事件%@",respondsStr);
            
        }
        
    }];
}


@end

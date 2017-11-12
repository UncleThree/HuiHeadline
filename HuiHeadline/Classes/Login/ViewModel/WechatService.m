//
//  WechatService.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/3.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "WechatService.h"
#import "WXApi.h"

@interface WechatService () <UIApplicationDelegate,WXApiDelegate>




///0 login 1 bind 2 authorize
@property (nonatomic, assign)NSInteger type;

@end

static WechatService *wechat = nil;

@implementation WechatService


+ (void)load {
    
    wechat = [WechatService new];
}

+ (WechatService *)sharedWechat {
    
    return wechat;
}

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @""
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"
#define WXPatient_App_ID WX_APPID
#define WXPatient_App_Secret WX_SECRET

- (void)loginToWechat:(WechatHandler)callback {
    
    self.type = 0;
    [self getWechatCodeWithCallback:callback];
    
}

- (void)bindToWechat:(WechatHandler)callback {
    
    self.type = 1;
    [self getWechatCodeWithCallback:callback];
}

- (void)authorizeToWechat:(void(^)(id error, HHWeixinAccount *account))callback {
    
    self.type = 2;
    [self getWechatCodeWithCallback:callback];
}

- (void)getWechatCodeWithCallback:(WechatHandler)callback {
    
    self.handler = callback;
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = [[NSBundle mainBundle] bundleIdentifier];
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}


- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSString *code = temp.code;
        if (code && ![code isEqualToString:@""]) {
            if (self.type == 0) {
                [self loginToCashToutiao:code];
            } else if (self.type == 1) {
                [self bindWechat:code];
            } else {
                [self authorizeWechat:code];
            }
            
        } else {
            [HHHeadlineAwardHUD showMessage:@"微信授权失败！" hideTouch:NO animated:YES duration:2];
        }
        
    }
    
    
}

- (void)bindWechat:(NSString *)code  {
    
    [HHLoginNetwork loginRequstByThirdPartyType:2 code:code callback:self.handler];
}

- (void)loginToCashToutiao:(NSString *)code {
    
    [HHLoginNetwork loginRequstByThirdPartyType:1 code:code callback:self.handler];
    
}

- (void)authorizeWechat:(NSString *)code {
    
    [HHLoginNetwork authorizeWeixinWithCode:code callback:self.handler];
}


#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    [HHHeadlineAwardHUD showMessage:@"您尚未安装微信！" hideTouch:NO animated:YES duration:2];
}

@end

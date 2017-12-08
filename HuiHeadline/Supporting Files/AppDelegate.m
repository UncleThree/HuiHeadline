//
//  AppDelegate.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "AppDelegate.h"
#import "HHRootViewController.h"
#import "XHLaunchAdManager.h"
#import "HHLoginViewController.h"
#import "WXApi.h"
#import "WechatService.h"
#import "AlipayService.h"
#import <UMMobClick/MobClick.h>
#import "HHFMDeviceManager.h"


@interface AppDelegate () <WXApiDelegate>

@property (nonatomic, assign)BOOL checkOver;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWechat];
    [self initUmeng];
    [self initFMDevice];
    
    [self loadAppWithLaunchAD:YES];
    return YES;
}


- (void)initWechat {
    
    [WXApi registerApp:WX_APPID];
}

- (void)initUmeng {
    //    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UM_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}




///同盾
- (void)initFMDevice {
    
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 准备SDK初始化参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
#ifdef DEBUG
    
//    [options setValue:@"sandbox" forKey:@"env"]; // TODO

    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
    
#else
    
    
    
#endif
    
    // 此处已经替换为您的合作方标识了
    [options setValue:@"huisuoping" forKey:@"partner"];
    // 使用上述参数进行SDK初始化
    void (^callbackdata)(NSString *blackBox)= ^(NSString *blackBox){
        
        [HHFMDeviceManager FMDeviceActivate];
    };
    [options setObject:callbackdata forKey:@"callback"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        manager->initWithOptions(options);
    });
    
}

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"


- (BOOL)firstLoad {
    
    return [self first:@"firstLaunch"];
}

- (BOOL)firstVideo {
    
    return [self first:@"firstVideo"];
}

- (BOOL)firstAward {
    
    return [self first:@"firstAward"];
}

- (BOOL)firstShareCircle {
    
    return [self first:@"firstShareCircle"];
}

- (BOOL)first:(NSString *)key {
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:key]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        return YES;
    } else {
        return NO;
    }
    
}

- (InstallType)isFirstLoadOrUpdate {
    
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return InstallTypeFirst;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return InstallTypeUpdate;
    }
    return InstallTypeNormal;
    
}




- (void)loadAppWithLaunchAD:(BOOL)launchAD   {
    
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = UIColor.whiteColor;
    if (launchAD) {
        
        self.window.rootViewController = [[UIViewController alloc] init];
//        [XHLaunchAdManager shareManager];
        [NSNotificationCenter.defaultCenter removeObserver:self];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adOver) name:@"ADPAGE_BACK" object:nil];
        [self checkLogin:2];
        
        
    } else {
        
        [self checkLogin:2];
        
    }
    
}

- (void)adOver {
    
    
}


- (void)checkLogin:(int)retry {
    
    __block int re = retry;
    if ([HHUserManager sharedInstance].currentUser) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!self.checkOver) {
                self.checkOver = YES;
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
            }
        });
        
        [HHLoginNetwork checkLogin:^(id error, id result) {
            
            if (self.checkOver) {
                return ;
            }
            self.checkOver = YES;
            if (result) {
                
                [HHLoginNetwork requestBSJson:^(BOOL bs) {
                    G.$.rootVC = [HHRootViewController new];
                    self.window.rootViewController =  G.$.rootVC;
                }];
                
            } else {
                if ([[(NSError *)error description] containsString:@"service unavailable"]) {
                    
                    re--;
                    if (re != 0) {
                        [self checkLogin:re];
                        return;
                    }
                }
                NSLog(@"%@",error);
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
            }
        }];
        
        
    } else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
    }
    
    
}






- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:(id)[WechatService sharedWechat]];
    return YES;
}

///原生支付宝跳转 <iOS9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipayService sharedAlipay] processAuth_V2Result:url];
        
    }  else if ([url.host isEqualToString:@"oauth"]) {
        [WXApi handleOpenURL:url delegate:(id)[WechatService sharedWechat]];
    }
    
    return YES;
}

///iOS 9.0之后的接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipayService sharedAlipay] processAuth_V2Result:url];
        
    } else if ([url.host isEqualToString:@"oauth"]) {
        [WXApi handleOpenURL:url delegate:(id)[WechatService sharedWechat]];
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"applicationDidBecomeActive" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

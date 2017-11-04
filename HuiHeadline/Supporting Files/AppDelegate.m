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

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:WX_APPID];
    
    [self loadAppWithLaunchAD:YES];
    return YES;
}



- (void)loadAppWithLaunchAD:(BOOL)launchAD   {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = UIColor.whiteColor;
    if (launchAD) {
        
        self.window.rootViewController = [[UINavigationController alloc] init];
        [XHLaunchAdManager shareManager];
        [NSNotificationCenter.defaultCenter removeObserver:self];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(checkLogin) name:@"ADPAGE_BACK" object:nil];
        [self checkLogin];
    } else {
        [self checkLogin];
    }
    
}


- (void)checkLogin {
    
    if ([HHUserManager sharedInstance].currentUser) {
        
        [HHLoginNetwork checkLogin:^(id error, id result) {
            if (error && [error isKindOfClass:[NSString class]] && [error isEqualToString:@"unauthorized"]) {
                
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HHLoginViewController new]];
                //重新登录
            } else if (result) {
                
                G.$.rootVC = [HHRootViewController new];
                self.window.rootViewController =  G.$.rootVC;
                
            } else {
                
                NSLog(@"%@",error);
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
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

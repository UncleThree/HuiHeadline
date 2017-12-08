//
//  OpenActivityUtil.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "OpenActivityUtil.h"
#import "HHBaseViewController.h"

@implementation OpenActivityUtil

+ (void)pushViewControllerWithModel:(ActivityModel *)model
                           originVC:(UIViewController *)originVC
                         hideBottom:(BOOL)hide {
    
    @try {
        NSString *vcString = nil;
        id data = nil;
//        if (![model.iospkg isEqualToString:@"com.cashtoutiao.ios"]) {
//            return;
//        }
        if (model.iosactivity) {
            
            vcString = model.iosactivity;
            
        } else if (model.activity) {
            
            if ([model.activity containsString:@"CustomBrowser"]) {
                vcString = @"CustomBrowserViewController";
            } else if ([model.activity containsString:@"FriendsActivity"]) {
                
                vcString = @"HHMineInvitedViewController";
            }
            else {
                NSLog(@"openActivity : %@", model.activity);
            }
        }
        if (model.iosdata && model.iosdata.count) {
            
            data = [model.iosdata[0] v];
            
        } else if (model.data && model.data.count) {
            
            data = [model.data[0] v];
            
        }
        originVC.hidesBottomBarWhenPushed = YES;
        HHBaseViewController *vc = [NSClassFromString(vcString) new];
        vc.open_data = data;
        [originVC.navigationController pushViewController:vc animated:YES];
        if (hide) {
            originVC.hidesBottomBarWhenPushed = NO;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"openActivity error : %@",exception);
    }
    
    
    
}

@end

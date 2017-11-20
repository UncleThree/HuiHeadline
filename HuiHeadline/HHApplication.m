//
//  HHApplication.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHApplication.h"

@implementation HHApplication

NSString *const notiScreenTouch = @"notiScreenTouch";

- (void)sendEvent:(UIEvent *)event {
    
    if (event.type == UIEventTypeTouches) {
        
        UITouch *touch = [event.allTouches anyObject];

        
        if (touch.phase == UITouchPhaseBegan || touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseMoved) {
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notiScreenTouch object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"event"]]];
            
        }
    }
    
    
    [super sendEvent:event];
}

@end

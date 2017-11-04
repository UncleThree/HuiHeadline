//
//  HHVideoDetailWebViewController+Award.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoDetailWebViewController+Award.h"

static int timerInterval = 0;

@implementation HHVideoDetailWebViewController (Award)

- (void)startTimer {
    
    if (HHUserManager.sharedInstance.timer) {
        return;
    }
    HHUserManager.sharedInstance.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:HHUserManager.sharedInstance.timer forMode:NSRunLoopCommonModes];
    //打开动画
    self.buttomView.progressView.progressView.notAnimated = NO;
}

- (void)addProgress {
    
    
    if (HHUserManager.sharedInstance.videoTime == self.totalTime) {
        
        NSLog(@"同步视频奖励");
        [self submitIncomeWithCoins:10];
        
    } else {
        
        self.buttomView.progress = (float)HHUserManager.sharedInstance.videoTime / (float)self.totalTime;
        timerInterval++;
        HHUserManager.sharedInstance.videoTime++;
        
        
    }
    
}

//提交奖励 (以每次response为准)
- (void)submitIncomeWithCoins:(int)coins {
    
    timerInterval = 0;
    [HHUserManager.sharedInstance.timer invalidate];
    HHUserManager.sharedInstance.timer = nil;
    //提交之后再清0
    self.buttomView.progress = 0;
    CGPoint center = CGPointMake(KWIDTH -  PROGRESS_KWIDTH / 2, Y(self.buttomView) + PROGRESS_KWIDTH / 2);
    [HHHeadlineAwardHUD showImageView:@"计时奖励" coins:coins animation:YES originCenter:center addToView:self.view duration:1.0];
    HHUserManager.sharedInstance.videoTime = 0;
    [self startTimer];
    
}




@end

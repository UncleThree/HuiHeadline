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
    
    if (HHUserManager.sharedInstance.videoTimer) {
        return;
    }
    HHUserManager.sharedInstance.videoTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:HHUserManager.sharedInstance.videoTimer forMode:NSRunLoopCommonModes];
    //打开动画
    self.buttomView.progressView.progressView.notAnimated = NO;
}

- (void)addProgress {
    
    
    if (HHUserManager.sharedInstance.videoTime == self.totalTime) {
        
        [self sych];
        
    } else {
        
        self.buttomView.progress = (float)HHUserManager.sharedInstance.videoTime / (float)self.totalTime;
        timerInterval++;
        HHUserManager.sharedInstance.videoTime++;
        
    }
    
}


- (void)sych {
    
    [self sychVideoDutation:^{
        [self sychVideoDutation:nil];
    }];
    
}

- (void)sychVideoDutation:(void(^)())callback {
    if (self.totalTime >= 30) {
        [HHHeadlineNetwork sychVideoDurationWithDuration:self.totalTime callback:^(id error, HHReadSychDurationResponse *response) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                if (response.state == 0) {
                    [self submitIncomeWithCoins:response.incCredit];
                } else if (response.state == 10) {
                    if (callback) {
                        callback();
                    }
                } else if (response.state == 1) {
                    [HHHeadlineAwardHUD showMessage:@"今日观看视频收益已达上限！" animated:YES duration:2];
                }
                
            }
        }];
    }
}

//提交奖励 (以每次response为准)
- (void)submitIncomeWithCoins:(int)coins {
    
    timerInterval = 0;
    [HHUserManager.sharedInstance.videoTimer invalidate];
    HHUserManager.sharedInstance.videoTimer = nil;
    //提交之后再清0
    self.buttomView.progress = 0;
    CGPoint center = CGPointMake(KWIDTH -  PROGRESS_KWIDTH / 2, Y(self.buttomView) + PROGRESS_KWIDTH / 2);
    [HHHeadlineAwardHUD showImageView:@"计时奖励" coins:coins animation:YES originCenter:center addToView:self.view duration:1.0];
    HHUserManager.sharedInstance.videoTime = 0;
    [self startTimer];
    
}




@end

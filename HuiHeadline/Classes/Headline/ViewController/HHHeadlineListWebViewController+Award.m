//
//  HHHeadlineListWebViewController+Award.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListWebViewController+Award.h"

/// 2s内的滑动事件只算一次
static BOOL once = NO;

static int timerInterval = 0;

@implementation HHHeadlineListWebViewController (Award) 




- (void)startTimer {
    [self startTimerWithTimerInterval:0];
}

- (void)startTimerWithTimerInterval:(int)interval {
    
    if (HHUserManager.sharedInstance.timer) {
        return;
    }
    self.boolUserScroll = NO;
    timerInterval = interval;
    HHUserManager.sharedInstance.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:HHUserManager.sharedInstance.timer forMode:NSRunLoopCommonModes];
    //打开动画
    self.circleProgress.progressView.notAnimated = NO;
    
}







- (void)addProgress {
    

    if (self.circleProgress.progressView.progress == 1 && !self.sychLock ) {
        
        [HHUserManager.sharedInstance.timer invalidate];
        HHUserManager.sharedInstance.timer = nil;
        self.sychLock = YES;
        
        [self award_sychDuration:^{
            //失败的时候重试一次(没有token)
            [self award_sychDuration:nil];
        }];
    } else {
        
        timerInterval++;
        HHUserManager.sharedInstance.readTime++;
        self.circleProgress.progressView.progress = (float)HHUserManager.sharedInstance.readTime / (float)self.totalTime;
        
        if (timerInterval == 5) {
            
            [HHUserManager.sharedInstance.timer invalidate];
            HHUserManager.sharedInstance.timer = nil;
            
        }
    }
    
}



- (void)award_sychDuration:(void (^)(void))callback {
    
    [self sychDuration:^(NSError *error, HHReadSychDurationResponse *response) {
        if (error) {
            NSLog(@"sychDuration error:%@",error);
        } else if (response.state == 0) {
            //成功
            [self submitIncomeWithCoins:response.incCredit];
        
            [self startTimerWithTimerInterval:timerInterval];
            
        } else if (response.state == 10) {
            NSLog(@"失败");
            if (callback) {
                callback();
            }
        } else if (response.state == 1) {
            [HHHeadlineAwardHUD showMessage:@"今日阅读收益已达上限！" animated:YES duration:2];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sychLock = NO;
        });
    }];
}


//提交奖励 (以每次response为准)
- (void)submitIncomeWithCoins:(int)coins {
    
    //提交之后再清0
    self.circleProgress.progressView.progress = 0;
    HHUserManager.sharedInstance.readTime = 0;
    CGPoint center = CGPointMake(PROGRESS_KWIDTH / 2, Y(self.circleProgress) + PROGRESS_KWIDTH / 2);
    [HHHeadlineAwardHUD showImageView:@"计时奖励" coins:coins animation:YES originCenter:center addToView:self.view duration:1.0];
    
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.urlDidload) {
        return;
    }
    if (HHUserManager.sharedInstance.timer && once) {
        
        timerInterval = 0;
        once = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    [self startTimer];
    once = YES;
    
}






- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    if ([navigationAction.request.URL.absoluteString containsString:@"openapp"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL]; 
    }
    
    if ([self.webView canGoBack]) {
        
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
        closeButtonItem.tintColor = BLACK_51;
        self.navigationItem.leftBarButtonItems = @[self.backItem, closeButtonItem];
        
    } else {
        self.navigationItem.leftBarButtonItem = self.backItem;
    }
    
    
}

- (void)closeAction {
    
    [self.navigationController popViewControllerAnimated:YES];

}










@end

//
//  HHHeadlineListWebViewController.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHHeadlineNewsDetailProgressView.h"
#import <WebKit/WebKit.h>
#import "HHBaseViewController.h"
#import "HHReadAnalyseUtil.h"

@class HHReadSychDurationResponse;

@interface HHHeadlineListWebViewController : HHBaseViewController

@property (nonatomic, copy)void (^clickCallback)(void);

@property(nonatomic,copy)NSString *URLString;

@property (nonatomic, strong)UIBarButtonItem *backItem;

@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)UIProgressView *progressView;

//
@property (nonatomic, strong)HHHeadlineNewsDetailProgressView *circleProgress;

///共多少秒提交奖励
@property (nonatomic, assign)int totalTime;

///url是否加载完成80% 之后的滑动动作才能算作用户滑动动作 
@property (nonatomic, assign)BOOL urlDidload;
///用户在5s内是否滑动了页面
@property (nonatomic, assign)BOOL boolUserScroll;
///同步阅读锁 保证只发起一次增加阅读请求
@property (nonatomic, assign)BOOL sychLock;

///同步时长
- (void)sychDuration:(void(^)(NSError *error,HHReadSychDurationResponse *response))callback;

@property (nonatomic, strong)AntifraudReadActionInfo *actionInfo;

@end

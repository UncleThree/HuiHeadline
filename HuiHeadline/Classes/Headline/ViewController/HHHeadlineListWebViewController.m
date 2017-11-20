//
//  HHHeadlineListWebViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListWebViewController.h"
#import "HHHeadlineListWebViewController+Award.h"
#import "HHHeadlineShareCollectionView.h"
#import "HHHeadlineListReadAwardViewController.h"
#import "HHReadSychDurationResponse.h"
#import "HHHeadlineNavController.h"
#import "HHReadWKWebView.h"

@interface HHHeadlineListWebViewController () < UIScrollViewDelegate, HHHeadlineShareCollectionViewDelegate, UIViewControllerPreviewingDelegate>

///模糊背景图
@property (nonatomic, strong)UIView *backGView;
///分享图
@property (nonatomic, strong)HHHeadlineShareCollectionView *shareView;

@property (nonatomic, strong)UIImageView *guideView;
@property (nonatomic, strong)UILabel *guideLabel;

@end

@implementation HHHeadlineListWebViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.webView.scrollView.delegate = self;
    
    if ([[self.navigationController class] isKindOfClass:[HHHeadlineNavController class]]) {
        [(HHHeadlineNavController *)self.navigationController setAppear:NO];
    }
    
    HHUserManager.sharedInstance.newsCount++;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(touch:) name:@"notiScreenTouch" object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [HHUserManager.sharedInstance.timer invalidate];
    HHUserManager.sharedInstance.timer = nil;
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"notiScreenTouch" object:nil];
}

- (void)touch:(NSNotification *)notification {
    
    if (notification.userInfo && notification.userInfo[@"event"]) {
        UIEvent *event = notification.userInfo[@"event"];
        UITouch *touch = event.allTouches.anyObject;
        if (touch.phase == UITouchPhaseBegan) {
            
            [self.actionInfo increaseDownMotionEvent:touch];
            
        } else if (touch.phase == UITouchPhaseMoved) {
            
      
            [self.actionInfo increaseMoveMotionEvent:touch];
        }
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    ///blog
    self.webView.scrollView.delegate = nil;
    
    [self.progressView removeFromSuperview];
    
}

- (void)viewDidLoad {
    

    [self initNavigation];
    [self initWebView];
    [self initProgressView];
    
    [super viewDidLoad];
}

- (AntifraudReadActionInfo *)actionInfo {
    if (!_actionInfo) {
        _actionInfo = [AntifraudReadActionInfo new];
    }
    return _actionInfo;
}


- (void)refresh {
    
    [super refresh];
    [self loadRequest];
}

- (void)initProgressView {
    
    self.circleProgress = ({
       HHHeadlineNewsDetailProgressView *progress = [[HHHeadlineNewsDetailProgressView alloc]initWithFrame:CGRectMake(0, 0, PROGRESS_KWIDTH, PROGRESS_KWIDTH)];
        [self.view addSubview:progress];
        progress;
    });
    _circleProgress.userInteractionEnabled = YES;
    [_circleProgress addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readAward)]];
    CGFloat padding = 0;
    [_circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(padding);
        make.top.equalTo(self.view.mas_bottom).with.offset(-padding - PROGRESS_KWIDTH);
        make.width.height.mas_equalTo(PROGRESS_KWIDTH);
    }];
    
    
    if (![HHUserManager sharedInstance].hasClick) {
        [self addGuideView];
    }
    
    [self initTime];
    
    
}



- (void)addGuideView {
    
    UIImage *image = [UIImage imageNamed:@"tp_bg"];
    self.guideView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.guideView.image = image;
    
    self.guideLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.guideLabel.textColor = [UIColor whiteColor];
    self.guideLabel.text = @"亲，点击可查看奖励规则，以及每日收益哦~";
    self.guideLabel.font = Font(15);
    self.guideLabel.numberOfLines = 0;
    [self.view addSubview:self.guideView];
    [self.view addSubview:self.guideLabel];
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.circleProgress.progressView.mas_top).with.offset(-5);
        make.left.equalTo(self.view).with.offset(10);
        make.height.mas_equalTo(65);
    }];
    
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.guideView).with.offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KWIDTH / 2);
        make.centerY.equalTo(self.guideView).with.offset(-3);
    }];
}

- (void)removeGuideView {
    
    [HHUserManager sharedInstance].hasClick = YES;
    [self.guideView removeFromSuperview];
    [self.guideLabel removeFromSuperview];
    
}

- (void)initTime {
    
    self.totalTime = (int)[HHUserManager sharedInstance].readConfig.durations;
    int readTime = [HHUserManager sharedInstance].readTime;
    if (readTime) {
        _circleProgress.progressView.notAnimated = YES;
        if (readTime > self.totalTime) {
            HHUserManager.sharedInstance.readTime = self.totalTime;
            readTime = HHUserManager.sharedInstance.readTime;
        }
    }
    _circleProgress.progressView.progress = (float)readTime / (float)self.totalTime;
}



- (void)initNavigation {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backItem = [[UIBarButtonItem alloc] initWithCustomView:[HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back)]];
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
   
    self.progressView.frame = CGRectMake(0, 44, KWIDTH, 2);
    [self.navigationController.navigationBar addSubview:self.progressView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareSDK)];
   
}

- (void)readAward {
    
    [self removeGuideView];
    
    
    HHHeadlineListReadAwardViewController *readVC = [HHHeadlineListReadAwardViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readVC animated:YES];
    
}

- (void)shareSDK {
    
    [self presentShareView];
    
    
}

- (void)sychDuration:(void(^)(NSError *error,HHReadSychDurationResponse *response))callback {
    
    if (self.totalTime >= 10) {
        
        [HHHeadlineNetwork sychDurationWithDuration:self.totalTime count:[HHUserManager sharedInstance].newsCount actionInfo:self.actionInfo  callback:^(NSError *error, id result) {
            
            callback(error,result);
        }];
    }
    
}

#define SHARE_HEIGHT 220

- (void)presentShareView {
    if (!_backGView) {
        _backGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - 64)];
        _backGView.backgroundColor = TRAN_BLACK;
        _backGView.userInteractionEnabled = YES;
        [_backGView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)]];
        [self.view addSubview:_backGView];
    }
    if (!_shareView) {
        _shareView = [[HHHeadlineShareCollectionView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_shareView];
        _shareView.frame = CGRectMake(0, KHEIGHT - 64, KWIDTH, SHARE_HEIGHT);
        _shareView.clickDelegate = self;
        
    }
    
    _backGView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, KHEIGHT - 64 - SHARE_HEIGHT, KWIDTH, SHARE_HEIGHT);
    }];
    
    
}

- (void)hideShareView {
    
    _backGView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, KHEIGHT - 64, KWIDTH, SHARE_HEIGHT);
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemText:(NSString *)text {
    
    [self hideShareView];
    NSLog(@"Share To %@",text);
}


- (void)initWebView {

    self.webView = [[HHReadWKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) ];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.webView.scrollView.canCancelContentTouches = NO;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    [self loadRequest];
  
}



- (void)loadRequest {
    
    if(!self.URLString) return;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
    [self.webView loadRequest:request];
}

- (void)back{
    
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        if (self.clickCallback) {
            self.clickCallback();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)startRead {
    
    self.urlDidload = YES;
    [self startTimer];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.progressView setProgress:progress animated:YES];
        
        ///加载到0.8时开始计时器
        
        if (progress >= 0.8 && self.webView.loading) {
            
            [self startRead];
            
        }
        if(progress == 1.0)
        {
            [self.progressView setProgress:0.0 animated:NO];
            
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

    
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}




@end

//
//  HHVideoDetailWebViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/30.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoDetailWebViewController.h"
#import <WebKit/WebKit.h>
#import "HHVideoDetailWebViewController+Award.h"
#import "HHHeadlineListReadAwardViewController.h"

@interface HHVideoDetailWebViewController () <WKNavigationDelegate, HHVideoDetalBottomViewDelegate>

@property (nonatomic,strong)WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;


@property (nonatomic, strong)UIImageView *awardImgV;

@property (nonatomic, strong)UIBarButtonItem *backItem;


@end

@implementation HHVideoDetailWebViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [HHUserManager.sharedInstance.videoTimer invalidate];
    HHUserManager.sharedInstance.videoTimer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.buttomView.hidden) {
        
        [self startTimer];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initWebView];
    [self initAwardImageView];
    [self initBottomView];
    

    
}

- (void)initAwardImageView {
    
    self.awardImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:@"income_abbrev.png"];
    self.awardImgV.image = image;
    [self.view addSubview:self.awardImgV];
    CGFloat height = 25;
    [self.awardImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-CGFLOAT(40));
        make.right.equalTo(self.view);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(image.size.width / image.size.height * height);
    }];
    self.awardImgV.userInteractionEnabled = YES;
    [self.awardImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwardImageView)] ];
}


- (void)initBottomView {
    
    self.buttomView = [[HHVideoDetailBottomView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 100)];
    self.buttomView.delegate = self;
    [self.view addSubview:self.buttomView];
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.width.mas_equalTo(KWIDTH);
        make.height.mas_equalTo(100);
    }];
    
    [self initTime];
    
    
}


- (void)initTime {
    
    self.totalTime = (int)[HHUserManager sharedInstance].readConfig.videoDurations;
    if (HHUserManager.sharedInstance.videoTime) {
        self.buttomView.progressView.progressView.notAnimated = YES;
    }
    self.buttomView.progress = (float)HHUserManager.sharedInstance.videoTime / (float)self.totalTime;
    
}



- (void)clickFold {
    
    self.buttomView.hidden = YES;
    
    [HHUserManager.sharedInstance.videoTimer invalidate];
    HHUserManager.sharedInstance.videoTimer = nil;
    
}

- (void)clickProgressView {
    
    HHHeadlineListReadAwardViewController *readVC = [HHHeadlineListReadAwardViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readVC animated:YES];
}

- (void)clickAwardImageView {
    
    self.buttomView.hidden = NO;
    
    [self startTimer];
}


- (void)initNavigation {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *backView = [HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back)];
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    _backItem.tintColor = BLACK_51;
    self.navigationItem.leftBarButtonItems = @[_backItem];
    
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
    
    self.progressView.frame = CGRectMake(0, 44, KWIDTH, 2);
    [self.navigationController.navigationBar addSubview:self.progressView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareSDK)];
    
}

- (void)shareSDK {
    
    
}



- (void)initWebView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if(!self.URLString) return;
    [self loadRequest];
    self.webView.navigationDelegate = self;
    
    
    
    
}


- (void)loadRequest {
    
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.progressView setProgress:progress animated:YES];
        
        if (progress >= 0.8) {
            
            [self startTimer];
        }
        if(progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.progressView setProgress:0.0 animated:NO];
            });
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}



- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
  
}

#pragma mark WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    if ([self.webView canGoBack]) {
        
        UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
        closeButtonItem.tintColor = BLACK_51;
        self.navigationItem.leftBarButtonItems = @[self.backItem, closeButtonItem];
        
        
    } else {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
        
   
}

- (void)closeAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

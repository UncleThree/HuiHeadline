//
//  HHHeadlineListWebViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHVideoListWebViewController.h"
#import <WebKit/WebKit.h>
#import "HHVideoDetailWebViewController.h"
#import "AppDelegate.h"

@interface HHVideoListWebViewController () <WKNavigationDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HHVideoListWebViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewDidLoad {
    
    [self initWebView];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([(AppDelegate *)UIApplication.sharedApplication.delegate firstVideo] && !G.$.bs) {
        [HHHeadlineAwardHUD showVideoReminderView];
    }
    
}


- (void)initWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
    
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
   
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    if(!self.URLString) return;
    [self loadRequest];
    self.webView.navigationDelegate = self;
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
    
    self.progressView.frame = CGRectMake(0, 0, KWIDTH, 2);
    [self.webView addSubview:self.progressView];
    [self.webView bringSubviewToFront:self.progressView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.webView.scrollView.mj_header = header;
    
    
}

- (void)refresh {
    
    [super refresh];
    
    [self loadRequest];
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

#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self.webView.scrollView.mj_header endRefreshing];
    

    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([strRequest isEqualToString:self.URLString]) {
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }  else {
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        
        
        HHVideoDetailWebViewController *detailWebVC = [[HHVideoDetailWebViewController alloc] init];
        detailWebVC.URLString = strRequest;
        detailWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailWebVC animated:YES];
        detailWebVC.hidesBottomBarWhenPushed = NO;
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}








@end

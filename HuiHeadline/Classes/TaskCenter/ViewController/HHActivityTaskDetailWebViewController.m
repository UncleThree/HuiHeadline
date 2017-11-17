//
//  HHActivityTaskDetailWebViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHActivityTaskDetailWebViewController.h"
#import <WebKit/WebKit.h>

@interface HHActivityTaskDetailWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;



@end

@implementation HHActivityTaskDetailWebViewController




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidLoad {
    
    [self initNavigation];
    [self initProgressView];
    [self initWebView];
    
    [super viewDidLoad];
}

- (void)refresh {
    
    [super refresh];
    [self loadRequest];
}

- (void)initNavigation {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:[@" " stringByAppendingString:self.activityTitle ?: @""]];
    [self.view addSubview:self.navigationView];
    
}

- (void)initProgressView {
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
    
    self.progressView.frame = CGRectMake(0, H(self.navigationView) - 2, KWIDTH, 2);
    [self.navigationView addSubview:self.progressView];
}

- (void)initWebView {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    self.webView.scrollView.bounces = NO;
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
        
        if(progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.progressView setProgress:0.0 animated:NO];
            });
        }
        
    } else if ([keyPath isEqualToString:@"title"]) {
        
        self.activityTitle = self.webView.title;
        [self initNavigation];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    [self loadRequest];
}









@end

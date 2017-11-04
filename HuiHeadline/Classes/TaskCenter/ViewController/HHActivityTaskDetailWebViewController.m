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

@property (nonatomic, strong)UIBarButtonItem *backItem;

@end

@implementation HHActivityTaskDetailWebViewController




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initWebView];
}

- (void)initNavigation {
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *backView = [HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back) text:[NSString stringWithFormat:@"  %@",self.activityTitle]];
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    _backItem.tintColor = BLACK_51;
    self.navigationItem.leftBarButtonItems = @[_backItem];
    
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
    
    self.progressView.frame = CGRectMake(0, 44, KWIDTH, 2);
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    
    
}

- (void)initWebView {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
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
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    [self loadRequest];
}









@end

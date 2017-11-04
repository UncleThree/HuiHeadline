//
//  HHHeadlineListAdWebViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListAdWebViewController.h"
#import <WebKit/WebKit.h>

@interface HHHeadlineListAdWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)UIProgressView *progressView;

@property (nonatomic, strong)UIBarButtonItem *backItem;

@end

@implementation HHHeadlineListAdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initWebView];
   
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
    
}
- (void)initWebView {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.bounces = NO;
    if(!self.URLString)
        return;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
    [self.webView loadRequest:request];
    self.webView.navigationDelegate = self;
}

- (void)back{
    
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        self.clickCallback();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
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
            [self.progressView setProgress:0.0 animated:NO];
            
            
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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

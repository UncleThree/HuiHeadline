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

@interface HHHeadlineListWebViewController () < UIScrollViewDelegate, HHHeadlineShareCollectionViewDelegate>



///模糊背景图
@property (nonatomic, strong)UIView *backView;
///分享图
@property (nonatomic, strong)HHHeadlineShareCollectionView *shareView;



@end

@implementation HHHeadlineListWebViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initWebView];
    [self initProgressView];
    
    
}





- (void)initProgressView {
    _circleProgress = ({
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
    
    [self initTime];
    
}

- (void)initTime {
    self.totalTime = (int)[HHUserManager sharedInstance].readConfig.durations;
    int readTime = [HHUserManager sharedInstance].readTime;
    if (readTime) {
        _circleProgress.progressView.notAnimated = YES;
    }
    _circleProgress.progressView.progress = (float)readTime / (float)self.totalTime;
}



- (void)initNavigation {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backItem = [[UIBarButtonItem alloc] initWithCustomView:[HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back)]];
    self.backItem.tintColor = BLACK_51;
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = HUIRED;
   
    self.progressView.frame = CGRectMake(0, 44, KWIDTH, 2);
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareSDK)];
   
}

- (void)readAward {
    

    HHHeadlineListReadAwardViewController *readVC = [HHHeadlineListReadAwardViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:readVC animated:YES];
    
}

- (void)shareSDK {
    
    [self presentShareView];
    
    
}

- (void)sychDuration:(void(^)(NSError *error,HHReadSychDurationResponse *response))callback {
    if (self.totalTime >= 30) {
        [HHHeadlineNetwork sychDurationWithDuration:self.totalTime callback:^(NSError *error, id result) {
            callback(error,result);
        }];
    }
    
}

#define SHARE_HEIGHT 220

- (void)presentShareView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - 64)];
        _backView.backgroundColor = TRAN_BLACK;
        _backView.userInteractionEnabled = YES;
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)]];
        [self.view addSubview:_backView];
    }
    if (!_shareView) {
        _shareView = [[HHHeadlineShareCollectionView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_shareView];
        _shareView.frame = CGRectMake(0, KHEIGHT - 64, KWIDTH, SHARE_HEIGHT);
        _shareView.clickDelegate = self;
        
    }
    
    _backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, KHEIGHT - 64 - SHARE_HEIGHT, KWIDTH, SHARE_HEIGHT);
    }];
    
    
}

- (void)hideShareView {
    
    _backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.frame = CGRectMake(0, KHEIGHT - 64, KWIDTH, SHARE_HEIGHT);
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemText:(NSString *)text {
    
    [self hideShareView];
    NSLog(@"Share To %@",text);
}



- (void)initWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces = NO;
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
        self.clickCallback();
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    
    [HHUserManager.sharedInstance.timer invalidate];
    HHUserManager.sharedInstance.timer = nil;
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
        
        if (progress >= 0.8) {
            
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







@end

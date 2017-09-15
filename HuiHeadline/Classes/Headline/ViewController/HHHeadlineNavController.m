//
//  HHHeadlineNavController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNavController.h"
#import "HHHeadlineEncrypt.h"
#import "HHHeadlineNetwork.h"

@interface HHHeadlineNavController () <MBProgressHUDDelegate>

@property (nonatomic ,strong)UIImageView *alarmImgv;

@property (nonatomic, strong)NSTimer *timer;
//倒计时秒数
@property (nonatomic)NSInteger countSecound;


@end

@implementation HHHeadlineNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTitleView];
    [self addLeft];
    [self addTimeLabel];
    [self startTimer];
}

- (void)addTitleView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    imgView.image = [UIImage imageNamed:@"titleView.png"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.center = self.navigationBar.center;
    [self.navigationBar addSubview:imgView];
}

- (void)addLeft {
    
    UIImageView *alarmImgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
    alarmImgv.image = [UIImage imageNamed:@"alarm.png"];
    alarmImgv.contentMode = UIViewContentModeScaleAspectFit;
    alarmImgv.center = CGPointMake(alarmImgv.center.x, self.navigationBar.center.y);
    [self.navigationBar addSubview:alarmImgv];
    self.alarmImgv = alarmImgv;
    self.alarmImgv.userInteractionEnabled = YES;
    [self.alarmImgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
    
    
}

- (void)addTimeLabel {
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.alarmImgv) + 5, Y(self.alarmImgv), 60, 25)];
    timeLabel.text = @"";
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    timeLabel.textColor = UIColor.redColor;
    [self.navigationBar addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
}

- (void)clickLeft {
    
    NSLog(@"click");
    
}

- (void)startTimer {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
//    NSInteger hh = [[currentTime componentsSeparatedByString:@":"][0] integerValue];
    NSInteger mm = [[currentTime componentsSeparatedByString:@":"][1] integerValue];
    NSInteger ss = [[currentTime componentsSeparatedByString:@":"][2] integerValue];
    //倒计时多少秒
    _countSecound = (59 - mm) * 60 + (60 - ss);
    _countSecound = 2;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    

}

- (void)countDownAction  {
    if (_countSecound) {
        _countSecound--;
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_countSecound%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",_countSecound%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        _timeLabel.text = format_time;
    } else {
        NSLog(@"领取奖励");
        [self.timer invalidate];
        
        [self postRequest];
        
    }
    
}

- (void)postRequest {
    [HHHeadlineNetwork getRewardsRequestWithUserId:800223 loginId:@"81e477a88b7344d9b712923cfcdc1528" appVersion:21 position:2 handler:^(id response, NSError *error) {
        if (response) {
            
            NSLog(@"??%@", response);
        } else {
            NSLog(@"%@", error);
        }
    }];

}






@end

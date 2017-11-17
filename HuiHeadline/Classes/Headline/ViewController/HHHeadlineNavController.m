//
//  HHHeadlineNavController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNavController.h"
#import "HHHeadlineAwardHUD.h"
#import "UITabBar+Badge.h"

@interface HHHeadlineNavController () <MBProgressHUDDelegate>

@property (nonatomic, strong)NSTimer *timer;
//倒计时秒数
@property (nonatomic)NSInteger countSecound;


@end

@implementation HHHeadlineNavController



- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if ([HHUserManager sharedInstance].loginId) {
        [self checkNewDay];
        [self checkHourAward];
    }
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
   
    
    
    
}

- (void)checkNewDay {
    
    
    if (![[HHDateUtil today] isEqualToString:HHUserManager.sharedInstance.today]) {
        
        HHUserManager.sharedInstance.today = [HHDateUtil today];
        [self.tabBarController.tabBar showBadgeOnItemIndex:2];
        
        
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTitleView];
    [self addLeft];
    [self addTimeLabel];
    [self startTimer];
    
    
    
}



- (void)addTitleView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT(20))];
    imgView.image = [UIImage imageNamed:@"titleView.png"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.center = self.navigationBar.center;
    [self.navigationBar addSubview:imgView];
    self.titleImgV = imgView;
}

- (void)addLeft {
    
    UIImageView *alarmImgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
    alarmImgv.image = [UIImage imageNamed:@"alarm.png"];
    alarmImgv.contentMode = UIViewContentModeScaleAspectFill;
    alarmImgv.center = CGPointMake(alarmImgv.center.x, self.navigationBar.center.y);
    [self.navigationBar addSubview:alarmImgv];
    self.alarmImgv = alarmImgv;
    self.alarmImgv.userInteractionEnabled = YES;
    [self.alarmImgv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
    
    
}

- (void)addTimeLabel {
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.alarmImgv) + 5, Y(self.alarmImgv), 60, 25)];
    timeLabel.text = @"";
    timeLabel.font = kSubtitleFont;
    timeLabel.textColor = UIColor.redColor;
    [self.navigationBar addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
}

- (void)clickLeft {
    
    [HHHeadlineAwardHUD showInstructionView];

}

- (void)checkHourAward {
    
    int hour = [HHDateUtil formatterHour];
    if (hour == [HHUserManager sharedInstance].lastPerHourAwardTime) {
        return;
    }
    [HHHeadlineNetwork sychRewardPerHourWithHour:hour callback:^(NSError *error, HHAwardPerHourResponse *response) {
        if (error) {
            Log(error);
        } else {
            if (response.statusCode == 200) {
                
                [HHUserManager sharedInstance].lastPerHourAwardTime = hour;
                if (self.appear) {
                    [self awardPerHourWithCoins:response.credit];
                }
                
            } else if (response.statusCode == -50) {
                ///获取过奖励
                [HHUserManager sharedInstance].lastPerHourAwardTime = hour;
            } else {
                
                NSLog(@"%zd, %@",response.statusCode, response.msg);
            }
        }
        
    }];
    
}



- (void)awardPerHourWithCoins:(int)coins {
    
    CGPoint center = CGPointMake(22, self.navigationBar.center.y);
    
    [HHHeadlineAwardHUD showImageView:@"弹框" coins:coins animation:YES originCenter:center addToView:self.view duration:1.0];
    
//    [HHHeadlineAwardHUD showMyViewWithCoins:coins originCenter:center addToView:self.view duration:1];
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
//    _countSecound = 2;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    

}

- (void)countDownAction  {
    if (_countSecound) {
        _countSecound--;
        NSString *str_minute = [NSString stringWithFormat:@"%02zd",(_countSecound%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02zd",_countSecound%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        _timeLabel.text = format_time;
    } else {

        [self.timer invalidate];
        self.timer = nil;
        
        [self startTimer];
       
        [self checkHourAward];
        
    }
    
}




@end

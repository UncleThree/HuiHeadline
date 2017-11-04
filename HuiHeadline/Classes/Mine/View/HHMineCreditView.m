//
//  HHMineCreditView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineCreditView.h"


@interface HHMineCreditView ()

@property (nonatomic, strong)HHMineCreditLabelView *todayCredit;


@property (nonatomic, strong)HHMineCreditLabelView *remainCredit;

@property (nonatomic, strong)HHMineCreditLabelView *totalCredit;

@property (nonatomic, strong)UIView *lineView1;
@property (nonatomic, strong)UIView *lineView2;

@end

@implementation HHMineCreditView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [self initWithFrame:frame summary:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame summary:(HHUserCreditSummary *)summary {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
        
        self.todayCredit = [[HHMineCreditLabelView alloc] initWithFrame:CGRectMake(0, 0, (KWIDTH - 2) / 3, frame.size.height) text1:summary.todayIncome ?: @"" text2:@"今日金币"];
        [self addSubview:self.todayCredit];
        
        
        self.lineView1 = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 3, frame.size.height / 3, 1, frame.size.height / 2)];
        self.lineView1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        [self addSubview:self.lineView1];
        
        self.remainCredit = [[HHMineCreditLabelView alloc] initWithFrame:CGRectMake(KWIDTH / 3 + 1, 0, (KWIDTH - 2) / 3, frame.size.height) text1:summary.remaining ?: @""text2:@"剩余金币"];
        [self addSubview:self.remainCredit];
        
        self.lineView2 = [[UIView alloc] initWithFrame:CGRectMake(KWIDTH / 3 * 2, frame.size.height / 3, 1, frame.size.height / 2)];
        self.lineView2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        [self addSubview:self.lineView2];
        
        self.totalCredit = [[HHMineCreditLabelView alloc] initWithFrame:CGRectMake(KWIDTH / 3 * 2 + 1, 0, (KWIDTH - 2) / 3, frame.size.height) text1:summary.total ?: @"" text2:@"总金币"];
        [self addSubview:self.totalCredit];
        
        
        
    }
    return self;
    
}



@end


@interface HHMineCreditLabelView ()

@property (nonatomic, strong)UILabel *creditNumLabel;
@property (nonatomic, strong)UILabel *creditLabel;

@end

@implementation HHMineCreditLabelView

- (instancetype)initWithFrame:(CGRect)frame text1:(NSString *)text1 text2:(NSString *)text2 {
    
    if (self = [super initWithFrame:frame]) {
        
        self.creditNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height / 2 - 10)];
        self.creditNumLabel.textColor = [UIColor whiteColor];
        self.creditNumLabel.font = Font(17);
        self.creditNumLabel.textAlignment = 1;
        self.creditNumLabel.text = [HHUtils insertComma:text1];
        [self addSubview:self.creditNumLabel];
        
        self.creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height / 2, W(self.creditNumLabel), frame.size.height / 2 - 10)];
        self.creditLabel.textColor = [UIColor whiteColor];
        self.creditLabel.font = Font(15);
        self.creditLabel.textAlignment = 1;
        self.creditLabel.text = text2;
        [self addSubview:self.creditLabel];
    }
        
    return self;
}

@end




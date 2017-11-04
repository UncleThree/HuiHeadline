//
//  HHMainHeaderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineHeaderView.h"
#import "HHMinePhoneView.h"
#import "HHMineCreditView.h"
#import "HHCreditSummaryResponse.h"

@interface HHMineHeaderView ()

@property (nonatomic, strong)UIImageView *backImgV;
@property (nonatomic, strong)UIButton *settingButton;
@property (nonatomic, strong)UIImageView *headPortraitImgV;
@property (nonatomic, strong)UILabel *nickNameLabel;

@property (nonatomic, strong)HHMinePhoneView *phoneView;

@property (nonatomic, strong)HHMineCreditView *creditView;



@end

@implementation HHMineHeaderView


- (instancetype)initWithFrame:(CGRect)frame
                         user:(HHUserModel *)user
                     summary:(HHUserCreditSummary *)summary{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI:frame user:user summary:summary];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame user:(HHUserModel *)user {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI:frame user:user summary:nil];
        
    }
    return self;
}


- (void)initUI:(CGRect)frame
          user:(HHUserModel *)user
      summary:(HHUserCreditSummary *)summary
{
    
    [self initBackView:&frame];
    
    [self initHeaderImageView:user];
    
    [self initNickNameLabel:user];
    
    [self initSettingButton];
    
    [self initPhoneView:user];
    
    [self addGesture];
    
    [self initBottomView:&frame summary:summary];
    
}

- (void)addGesture {
    self.headPortraitImgV.userInteractionEnabled = YES;
    self.nickNameLabel.userInteractionEnabled = YES;
    self.phoneView.userInteractionEnabled = YES;
    [self.headPortraitImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mineHeaderViewclick)]];
    [self.nickNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mineHeaderViewclick)]];
    [self.phoneView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mineHeaderViewclick)]];
    [self.settingButton addTarget:self action:@selector(mineHeaderViewclick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mineHeaderViewclick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderViewDidClick)]) {
        [self.delegate mineHeaderViewDidClick];
    }
    
}



- (void)initBackView:(const CGRect *)frame {
    self.backImgV = [[UIImageView alloc] initWithFrame:*frame];
    self.backImgV.image = [UIImage imageNamed:@"mine_back"];
    [self addSubview:self.backImgV];
}

- (void)initHeaderImageView:(HHUserModel *)user {
    CGFloat headWidth = 60;
    self.headPortraitImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headWidth, headWidth)];
   
    [self.headPortraitImgV sd_setImageWithURL:user ? URL(user.userInfo.headPortrait) : nil placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
    
    self.headPortraitImgV.layer.cornerRadius = headWidth / 2.0;
    self.headPortraitImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.headPortraitImgV.clipsToBounds = YES;
    [self addSubview:self.headPortraitImgV];
    
    CGFloat leftPadding = CGFLOAT(36);
    CGFloat topPadding = CGFLOAT(30);
    [self.headPortraitImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(leftPadding);
        make.top.equalTo(self).with.offset(topPadding);
        make.width.and.height.mas_equalTo(headWidth);
    }];
}

- (void)initNickNameLabel:(HHUserModel *)user {
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWIDTH * 2 / 3, 30)];
    self.nickNameLabel.text = user ? [self defaultNickName:user] : @"昵称";
    self.nickNameLabel.font = Font(20);
    self.nickNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headPortraitImgV.mas_top);
        make.left.equalTo(self.headPortraitImgV.mas_right).with.offset(18);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(30);
    }];
}

- (NSString *)defaultNickName:(HHUserModel *)user {
    if (!user.loginId) {
        return @"";
    }
    if (user.userInfo.nickName) {
        return user.userInfo.nickName;
    }
    NSString *registStr = [NSString stringWithFormat:@"%ld",user.userInfo.registerTime];
    NSString *lastSixRegistTime = [registStr substringFromIndex:registStr.length - 6];
    return [@"惠友" stringByAppendingString:lastSixRegistTime];
}

- (void)initSettingButton {
    CGFloat settingWidth = 20;
    self.settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, settingWidth, settingWidth)];
    [self.settingButton setImage:[[UIImage imageNamed:@"setting"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [self addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(settingWidth);
        make.right.equalTo(self).with.offset(-16);
        make.top.equalTo(self).with.offset(16);
    }];
}

- (void)initPhoneView:(HHUserModel *)user {
    self.phoneView = [[HHMinePhoneView alloc] initWithFrame:CGRectMake(0, 0, 250, 30) phone:user.userInfo.phone_sec];
    self.phoneView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom);
    }];
}

- (void)initBottomView:(const CGRect *)frame summary:(HHUserCreditSummary *)summary {
    CGFloat BottomHeight = frame->size.height / 3;
    self.creditView = [[HHMineCreditView alloc] initWithFrame:CGRectMake(0, frame->size.height - BottomHeight, KWIDTH, BottomHeight) summary:summary];
    [self addSubview:self.creditView];
}






@end

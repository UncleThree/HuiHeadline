//
//  HHMineInvitedOneImageTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/7.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineInvitedOneImageTableViewCell.h"

@interface HHMineInvitedOneImageTableViewCell ()


@property (nonatomic, strong)UIImageView *imgV1;

@property (nonatomic, strong)UIButton *fillCodeButton;
@property (nonatomic, strong)UIButton *stButton;


@end

@implementation HHMineInvitedOneImageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    self.imgV1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgV1];
    self.imgV1.contentMode = UIViewContentModeScaleAspectFill;
    self.imgV1.clipsToBounds = YES;
    
    
    self.fillCodeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.fillCodeButton.backgroundColor = RGB(254, 217, 216);
    self.fillCodeButton.layer.cornerRadius = 5;
    [self.fillCodeButton setTitle:@"填写师傅邀请码" forState:(UIControlStateNormal)];
    self.fillCodeButton.titleLabel.font = Font(15);
    [self.fillCodeButton setTitleColor:RGB(247, 43, 59) forState:(UIControlStateNormal)];
    [self.contentView addSubview:self.fillCodeButton];
    [self.fillCodeButton addTarget:self action:@selector(fillCode) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.stButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.stButton.backgroundColor = RGB(56, 163, 226);
    self.stButton.layer.cornerRadius = 5;
    [self.stButton setTitle:@"立即收徒" forState:(UIControlStateNormal)];
    self.stButton.titleLabel.font = Font(15);
    [self.contentView addSubview:self.stButton];
    [self.stButton addTarget:self action:@selector(stNow) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}

- (void)fillCode {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitedCellFillCode)]) {
        [self.delegate invitedCellFillCode];
    }
    
}

- (void)stNow {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitedCellstNow)]) {
        [self.delegate invitedCellstNow];
    }
    
}


- (void)setModel:(HHInvitedItem *)model {
    
    _model = model;
    if (!model) {
        return;
    }
    if (model.isBanner) {
        [self initImgV1:model buttonNumber:0 callback:nil];
        self.imgV1.userInteractionEnabled = YES;
        [self.imgV1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBanner)]];
    } else {
        [self initImgV1:model buttonNumber:model.isInvited ? 1 : 2 callback:nil];
    }
    
}

- (void)clickBanner {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBanner:)]) {
        [self.delegate clickBanner:self.model.targetLinkUrl];
    }
}

- (void)initImgV1:(HHInvitedItem *)model
     buttonNumber:(int)buttonNumber
         callback:(void(^)())callback{
    if (!model.imgUrl) {
        return;
    }
    [self.imgV1 sd_setImageWithURL:URL([model imgUrl]) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return;
        }
        self.imgV1.frame = CGRectMake(0, 0, KWIDTH, image.size.height / image.size.width * KWIDTH);
        self.imgV1.image = image;
        if (buttonNumber == 1) {
            CGFloat buttonHeight = 35;
            self.stButton.frame = CGRectMake(12, MaxY(self.imgV1) - 15 - buttonHeight, KWIDTH - 2 * 12, buttonHeight);
            self.fillCodeButton.hidden = YES;
        } else if (buttonNumber == 2) {
            CGFloat buttonHeight = 35;
            CGFloat width = (KWIDTH - 3 * 12) / 2;
            self.fillCodeButton.frame = CGRectMake(12, MaxY(self.imgV1) - 15 - buttonHeight, width, buttonHeight);
            self.stButton.frame = CGRectMake(MaxX(self.fillCodeButton) + 12, Y(self.fillCodeButton), width, buttonHeight);
            self.fillCodeButton.hidden = NO;
        } else {
            [self.fillCodeButton removeFromSuperview];
            [self.stButton removeFromSuperview];
        }
        if (callback) {
            callback();
        }
    }];
}







@end

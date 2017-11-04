//
//  HHMineInvitedImageTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineInvitedImageTableViewCell.h"

@interface HHMineInvitedImageTableViewCell ()

@property (nonatomic, strong)UIImageView *imgV1;
@property (nonatomic, strong)UIImageView *imgV2;
@property (nonatomic, strong)UIImageView *imgV3;

@property (nonatomic, strong)UIButton *fillCodeButton;
@property (nonatomic, strong)UIButton *stButton;

@end

@implementation HHMineInvitedImageTableViewCell




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
    
    self.imgV2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgV2];
    self.imgV2.contentMode = UIViewContentModeScaleAspectFill;
    self.imgV2.clipsToBounds = YES;
    
    self.imgV3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgV3];
    self.imgV3.contentMode = UIViewContentModeScaleAspectFill;
    self.imgV3.clipsToBounds = YES;
    
    self.fillCodeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.fillCodeButton.backgroundColor = RGB(254, 217, 216);
    self.fillCodeButton.layer.cornerRadius = 5;
    [self.fillCodeButton setTitle:@"填写师傅邀请码" forState:(UIControlStateNormal)];
    self.fillCodeButton.titleLabel.font = Font(15);
    [self.fillCodeButton setTitleColor:RGB(247, 43, 59) forState:(UIControlStateNormal)];
    [self.contentView addSubview:self.fillCodeButton];
    
    self.stButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.stButton.backgroundColor = RGB(56, 163, 226);
    self.stButton.layer.cornerRadius = 5;
    [self.stButton setTitle:@"立即收徒" forState:(UIControlStateNormal)];
    self.stButton.titleLabel.font = Font(15);
    [self.contentView addSubview:self.stButton];
    
    
}

- (void)setModels:(NSMutableArray<HHInvitedItem *> *)models {
    

    if (models.count == 1) {
        
        [self initImgV1:models[0] buttonNumber:2 callback:nil];
        
        
    } else if (models.count == 3) {
        
        [self initImgV1:models[0] buttonNumber:0 callback:^{
            [self initImgV2:models[1] callback:^{
                [self initImgV3:models[2] callback:^{
                    
                }];
            }];
        }];
        
    }
    
    // [mgr.imageCache clearMemory];
}

- (void)initImgV1:(HHInvitedItem *)model
     buttonNumber:(int)buttonNumber
         callback:(void(^)())callback{
    
    [self.imgV1 sd_setImageWithURL:URL([model imgUrl]) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.imgV1.frame = CGRectMake(0, 0, KWIDTH, image.size.height / image.size.width * KWIDTH);
        self.imgV1.image = image;
        if (buttonNumber == 1) {
            CGFloat buttonHeight = 35;
            self.stButton.frame = CGRectMake(12, MaxY(self.imgV1) - 15 - buttonHeight, KWIDTH - 2 * 12, buttonHeight);
        } else if (buttonNumber == 2) {
            CGFloat buttonHeight = 35;
            CGFloat width = (KWIDTH - 3 * 12) / 2;
            self.fillCodeButton.frame = CGRectMake(12, MaxY(self.imgV1) - 15 - buttonHeight, width, buttonHeight);
            self.stButton.frame = CGRectMake(MaxX(self.fillCodeButton) + 12, Y(self.fillCodeButton), width, buttonHeight);
            
        } else {
            [self.stButton removeFromSuperview];
            [self.fillCodeButton removeFromSuperview];
        }
        if (callback) {
            callback();
        }
    }];
}


- (void)initImgV2:(HHInvitedItem *)model
         callback:(void(^)())callback {
    
    [self.imgV2 sd_setImageWithURL:URL([model imgUrl]) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.imgV2.frame = CGRectMake(0, MaxY(self.imgV1), KWIDTH, image.size.height / image.size.width * KWIDTH);
        self.imgV2.image = image;
        callback();
    }];
    
}

- (void)initImgV3:(HHInvitedItem *)model
         callback:(void(^)())callback {
    
    [self.imgV3 sd_setImageWithURL:URL([model imgUrl]) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.imgV3.frame = CGRectMake(0, MaxY(self.imgV2), KWIDTH, image.size.height / image.size.width * KWIDTH);
        self.imgV3.image = image;
        callback();
    }];
    
}



@end



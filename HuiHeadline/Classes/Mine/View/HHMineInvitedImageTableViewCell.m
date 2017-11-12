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



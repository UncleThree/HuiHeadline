//
//  HHMainPhoneView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMinePhoneView.h"

@interface HHMinePhoneView ()

@property (nonatomic, strong)UIImageView *linkImgV;

@property (nonatomic, strong)UILabel *phoneLabel;

@end

@implementation HHMinePhoneView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [self initWithFrame:frame phone:nil];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame phone:(NSString *)phone {
    
    if (self = [super initWithFrame:frame]) {
       
        [self initUIWithFrame:frame phone:phone];
    }
    return self;
    
}

- (void)initUIWithFrame:(CGRect)frame
                  phone:(NSString *)phone {
    if (!phone || [phone isEqualToString:@""]) {
        
        CGFloat imgHeight = 5;
        UIImage *linkImage = [[UIImage imageNamed:@"链接"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        self.linkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 - imgHeight / 2, linkImage.size.width / linkImage.size.height * imgHeight, imgHeight)];
        self.linkImgV.image = linkImage;
        [self addSubview:self.linkImgV];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxY(self.linkImgV) + 5, 0, 200, frame.size.height)];
        self.phoneLabel.text = @"未绑定手机";
        self.phoneLabel.font = Font(15);
        self.phoneLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        [self addSubview:self.phoneLabel];
        
        
    } else {
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.phoneLabel.text = phone;
        self.phoneLabel.font = Font(15);
        self.phoneLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.phoneLabel];
    }
    
}







@end

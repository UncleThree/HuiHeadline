//
//  HHBannerResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface BannerInfo : NSObject

@property (nonatomic, assign)NSInteger banner_id;

@property (nonatomic, assign)NSInteger position;

@property (nonatomic, assign)NSInteger state;

@property (nonatomic, strong)NSString *picture;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, assign)NSInteger weight;

@end

@interface HHBannerResponse : HHResponse

@property (nonatomic, strong)NSArray<BannerInfo *> *banners;

@end

//
//  HHProductResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/2.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHProductInfo : NSObject

@property (nonatomic, copy)NSString *bigPicture;

@property (nonatomic, assign)NSInteger category;

@property (nonatomic, assign)NSInteger productInfoId;

@property (nonatomic, copy)NSString *itemMap;

@property (nonatomic, copy)NSString *items;

@property (nonatomic, assign)NSInteger leftNum;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign)NSInteger originalPrice;

@property (nonatomic, assign)NSInteger saleNum;

@property (nonatomic, assign)NSInteger salePrice;

@property (nonatomic, assign)NSInteger state;

@property (nonatomic, copy)NSString *subtitle;

@property (nonatomic, copy)NSString *thumbnail;

@end

@interface HHProductResponse : HHResponse

@property (nonatomic, strong)HHProductInfo *productInfo;

@end

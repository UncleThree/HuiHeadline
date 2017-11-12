//
//  HHOrderResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/31.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

@interface HHOrderInfo : NSObject

@property (nonatomic, assign)NSInteger channel;

@property (nonatomic, assign)NSInteger count;

@property (nonatomic, assign)NSInteger createTime;

@property (nonatomic, assign)NSInteger orderId;

@property (nonatomic, assign)NSInteger lastModifiedTime;

@property (nonatomic, assign)NSInteger originalPrice;

@property (nonatomic, assign)NSInteger productCategory;

@property (nonatomic, assign)NSInteger productId;

@property (nonatomic, copy)NSString *productName;

@property (nonatomic, copy)NSString *productThumbnail;

@property (nonatomic, copy)NSString *salePrice;
///0 已提交？
@property (nonatomic, assign)NSInteger state;

@property (nonatomic, copy)NSString *stateName;

//detailInfo

@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)NSString *feedback;

@property (nonatomic, strong)NSString *message;

@property (nonatomic, assign)BOOL isDetail;

@end

@interface HHOrderResponse : HHResponse

@property (nonatomic, strong)NSMutableArray<HHOrderInfo *> *orderInfoList;

///详情
@property (nonatomic, strong)HHOrderInfo *orderInfo;

@end

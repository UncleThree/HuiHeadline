//
//  HHUserDeliveryAddress.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/9.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUserDeliveryAddress : NSObject


@property (nonatomic, assign)NSInteger address_id;

@property (nonatomic, copy)NSString *addressProvince;

@property (nonatomic, copy)NSString *addressCity;

@property (nonatomic, copy)NSString *addressStreet;

@property (nonatomic, copy)NSString *addressZone;

@property (nonatomic, copy)NSString *addressZipCode;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *userPhone;

@property (nonatomic, assign)NSInteger createTime;

@property (nonatomic, assign)NSInteger lastModifiedTime;

@property (nonatomic, assign)BOOL isChecek;


@end

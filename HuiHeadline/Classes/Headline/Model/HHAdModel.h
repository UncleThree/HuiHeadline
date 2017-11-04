//
//  HHAdModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/9.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHBaseModel.h"

@interface HHAdModel : HHBaseModel
///
@property (nonatomic, copy)NSArray<NSString *> *clickReportList;
///cell类型
@property (nonatomic, assign)int displayType;
///
@property (nonatomic, copy)NSArray<NSString *> *exposureReportList;
///
@property (nonatomic, copy)NSArray<NSString *> *imgList;
///
@property (nonatomic, copy)NSString *landingUrl;

@property (nonatomic, copy)NSString *subTitle;

@property (nonatomic, copy)NSString *title;
///ADXHI
@property (nonatomic, copy)NSString *type;


// 钱包图片和+200金币的Label 设为nil或者不设置代表没有
@property (nonatomic, copy)NSString *AdAwards;



@end

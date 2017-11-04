//
//  HHProductIndoResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"



@interface HHProductOutline : NSObject

@property (nonatomic, assign)NSInteger category;

@property (nonatomic, assign)NSInteger productOutlineId;

@property (nonatomic, assign)NSInteger leftNum;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign)NSInteger originalPrice;

@property (nonatomic, assign)NSInteger salePrice;


@property (nonatomic, copy)NSString *subtitle;

@property (nonatomic, copy)NSString *thumbnail;


@end

@interface HHProductIndoResponse : HHResponse

@property (nonatomic, strong)NSArray<HHProductOutline *> *productOutlineList;

@end

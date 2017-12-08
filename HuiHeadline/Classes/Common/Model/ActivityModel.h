//
//  ActivityModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OpenActivityDataBean : NSObject

@property (nonatomic, strong)NSString *k;

@property (nonatomic, strong)NSString *v;

@property (nonatomic, strong)NSString *t;


@end

@interface ActivityModel : NSObject

@property (nonatomic, strong)NSString *activity;

@property (nonatomic, strong)NSArray<OpenActivityDataBean *>  *data;

@property (nonatomic, strong)NSString *pkg;

@property (nonatomic, strong)NSString *iosactivity;

@property (nonatomic, strong)NSArray<OpenActivityDataBean *>  *iosdata;

@property (nonatomic, strong)NSString *iospkg;

@end

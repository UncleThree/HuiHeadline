//
//  HHAwardPerHourResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/16.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHAwardPerHourResponse : NSObject

@property (nonatomic)int statusCode;

@property (nonatomic)int credit;

@property (nonatomic, copy)NSString *msg;


@end

//
//  HHReadSychDurationRequest.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHReadAnalyseUtil.h"

@interface HHReadSychDurationRequest : NSObject

@property (nonatomic)int duration;

@property (nonatomic)int count;

@property (nonatomic, copy)NSString *channel;

@property (nonatomic)long token;

@property (nonatomic, copy)NSString *virifyCode;

@property (nonatomic, strong)AntifraudReadActionInfo *readActionInfo;


@end

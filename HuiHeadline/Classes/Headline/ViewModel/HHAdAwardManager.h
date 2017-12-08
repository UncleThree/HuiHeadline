//
//  HHAdAwardManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHSychAdExposureResponse.h"

@interface HHAdAwardManager : NSObject

+ (instancetype)sharedInstance ;

- (void)disposeEncourageInfoMap:(NSDictionary *)dict;

- (ListAdEncourageInfo *)getEncourageInfoMap:(NSString *)channel;

@end

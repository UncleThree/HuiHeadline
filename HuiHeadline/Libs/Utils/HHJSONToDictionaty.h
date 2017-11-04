//
//  HHJSONToDictionaty.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHJSONToDictionaty : NSObject

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

//
//  HHResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHResponse : NSObject

@property (nonatomic, assign)int statusCode;

@property (nonatomic, copy)NSString *msg;

@end

//
//  AlipayService.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/3.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayService : NSObject

+ (AlipayService *)sharedAlipay;

- (void)loginToAli:(void(^)(id error , id result))callback ;

- (void)processAuth_V2Result:(NSURL *)url;

@end

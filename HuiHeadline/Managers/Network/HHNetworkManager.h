//
//  HHNetworkManager.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHNetworkManager : NSObject

+ (void)GET:(NSString *)url
 parameters:(id)parameters
    handler:(void(^)(id error, id result))handler;


+ (void)postRequestWithUrl:(NSString *)url
                parameters:(id)parameters
           isEncryptedJson:(BOOL)isEncryptedJson
                  otherArg:(NSDictionary *)options //requestType : json
                   handler:(void(^)(NSString *respondsStr, NSError *error))handler;

@end

//
//  HHHeadlineNetwork.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineNetwork.h"
#import "HHHeadlineEncrypt.h"
#import "HHJSONToDictionaty.h"
@implementation HHHeadlineNetwork

+ (void)getRewardsRequestWithUserId:(long)userId
                            loginId:(NSString *)loginId
                         appVersion:(int)appVersion
                           position:(int)position
                            handler:(void (^)(id response, NSError *error))handler {
    
    NSString *url = @"http://api.cashtoutiao.com/frontend/credit/sych/reward/per/hour";
    
//    url = @"http://192.168.0.151:8080/frontend/credit/sych/reward/per/hour";
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?userId=%ld&loginId=%@", userId, loginId]];
    
    NSDictionary *parameters = @{
                                 @"userId":[NSNumber numberWithLong:userId],
                                 @"loginId":loginId,
                                 @"position":[NSNumber numberWithInt:position],
                                 @"appVersion":[NSNumber numberWithInt:appVersion]
                                 };
    NSString *jsonStr = [HHJSONToDictionaty convertToJsonData:parameters];
    NSLog(@"jsonStr:%@",jsonStr);
    id encodeStr = [HHHeadlineEncrypt aes256_encrypt:nil Encrypttext:jsonStr];
    NSLog(@"encodeStr:%@",encodeStr);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer
     setValue:@"application/encrypted-json"
     forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer
     setValue:@"application/encrypted-json"
     forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"request header:%@", manager.requestSerializer.HTTPRequestHeaders);
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:encodeStr progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        handler(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        handler(nil, error);
        
    }];
    
    
    
}



@end

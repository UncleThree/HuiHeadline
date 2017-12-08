//
//  AsyncImageUtil.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageUtil : NSObject

+ (void)cachePictures:(NSArray *)urls
             callback:(void(^)())callback;

+ (void)checkCache:(NSString *)url
          callback:(void(^)())callback;

@end

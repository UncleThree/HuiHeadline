//
//  AsyncImageUtil.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/28.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "AsyncImageUtil.h"

@implementation AsyncImageUtil


+ (void)cachePictures:(NSArray *)urls
             callback:(void(^)())callback {
    
    dispatch_group_t group = dispatch_group_create();
    for (NSString *url in urls) {
        dispatch_group_enter(group);
        [self checkCache:url callback:^{
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        callback();
    });
}


+ (void)checkCache:(NSString *)url
          callback:(void(^)())callback {
    
    if (![[SDImageCache sharedImageCache] imageFromCacheForKey:url]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL(url) options:(SDWebImageDownloaderHighPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            if (image && finished) {
                ///写入缓存
                [[SDImageCache sharedImageCache] storeImage:image forKey:url completion:^{
                    callback();
                }];
            }
        }];
    } else {
        callback();
    }
    
}

@end

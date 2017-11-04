//
//  $.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "G.h"


static G *$ = nil;

@implementation G

+ (instancetype)$ {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        $ = [[G alloc] init];
    });
    return $;
}

- (NSCache *)taskCenterCache {
    if (!_taskCenterCache) {
        _taskCenterCache = [[NSCache alloc] init];
    }
    return _taskCenterCache;
}


@end

//
//  HHAdAwardManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHAdAwardManager.h"

@interface HHAdAwardManager ()

@property (nonatomic, strong)NSMutableDictionary *map;

@property (nonatomic, strong)NSCache *cache;

@end

static HHAdAwardManager *manager;

@implementation HHAdAwardManager


+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HHAdAwardManager new];
    });
    return manager;
}

- (NSCache *)cache {
    
    if (!_cache) {
        _cache = [NSCache new];
    }
    return _cache;
}

- (NSMutableDictionary *)map {
    
    if (!_map) {
        _map = [NSMutableDictionary dictionary];
    }
    return _map;
    
}

- (void)disposeEncourageInfoMap:(NSDictionary *)dict {
    
    long userId = HHUserManager.sharedInstance.userId;
    if (!userId) {
        return;
    }
    if (![self.cache objectForKey:@(userId)]) {
        [self.cache setObject:[NSMutableDictionary dictionary] forKey:@(userId)];
    }
    
    
    for (NSDictionary *key in dict) {
        
        NSMutableDictionary *mdict = [(NSDictionary *)dict[key] mutableCopy];
        [mdict setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"startTime"];
        
        [[self.cache objectForKey:@(userId)] setObject:mdict forKey:key];
        [self.map setObject:mdict forKey:key];
        
    }
    
    [self writeToDocument:self.map.copy];
    
}

- (ListAdEncourageInfo *)getEncourageInfoMap:(NSString *)channel {
    
    long userId = HHUserManager.sharedInstance.userId;
    if (!userId) {
        return nil;
    }
    
    if (self.cache && [self.cache objectForKey:@(userId)] && [[self.cache objectForKey:@(userId)] objectForKey:channel] ) {
        ListAdEncourageInfo *encourageInfo = [ListAdEncourageInfo mj_objectWithKeyValues:[[self.cache objectForKey:@(userId)] objectForKey:channel]];
        if (encourageInfo && encourageInfo.startTime && [[NSDate date] timeIntervalSince1970] - encourageInfo.startTime > encourageInfo.avaliableSeconds) {
            return nil;
        }
        return encourageInfo;
    }
    NSString *documentsPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dicPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ad-award-%ld.plist",userId]];
    NSDictionary *encourageInfoMap = [[NSDictionary alloc] initWithContentsOfFile:dicPath];
    if (encourageInfoMap && [encourageInfoMap objectForKey:channel]) {
        ListAdEncourageInfo *encourageInfo = [ListAdEncourageInfo mj_objectWithKeyValues:[encourageInfoMap objectForKey:channel]];
        if (encourageInfo && encourageInfo.startTime && [[NSDate date] timeIntervalSince1970] - encourageInfo.startTime > encourageInfo.avaliableSeconds ) {
            return nil;
        }
        return encourageInfo;
    }
    return nil;
}


- (void)writeToDocument:(NSDictionary *)dict {
    
    long userId = HHUserManager.sharedInstance.userId;
    if (!userId) {
        return;
    }
    NSString *documentsPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dicPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ad-award-%ld.plist",userId]];
    [dict writeToFile:dicPath atomically:YES];
    
}



@end

//
//  HHHeadlineNetwork.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/26.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHNewsModel.h"
#import "HHAdRequest.h"
#import "HHAdStrategy.h"
#import "HHReadIncomeDetailResponse.h"
#import "HHReadSychDurationRequest.h"
#import "HHReadSychDurationResponse.h"
#import "HHTopNewsModel.h"

@implementation HHHeadlineNetwork


static int pgnumD = 0;
static int pgnumA = 0;
static int pgnum = 0;
static int idx = 0;
static int pageSize = 0;
static int idxD = 0;
static int idXA = 0;
static NSString *startkey = nil;
static NSString *newkey = nil;

+ (void)reset {
    pgnumD = 0;
    pgnumA = 0;
    pgnum = 0;
    idx = 0;
    pageSize = 0;
    idxD  = 0;
    idXA = 0;
    startkey = nil;
    newkey = nil;
}

+ (void)requestForNewsWithType:(NSString *)type
                       isFirst:(BOOL)isFirst
                       refresh:(BOOL)refresh //是否是下拉加载
                       handler:(Block)handler {
    if (isFirst) {
        
        [self reset];
        
    } else if (refresh) {
        pgnumD--;
        idx = idxD - pageSize;
        pgnum = pgnumD;
        idxD = idx;
    } else {
        pgnumA++;
        idx = idXA + pageSize;
        pgnum = pgnumA;
        idXA = idx;
    }
    [HHNetworkManager postRequestWithUrl:k_getkey_url parameters:nil isEncryptedJson:NO otherArg:nil  handler:^(NSString *respondsStr, NSError *error) {
        
        if (respondsStr) {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            if (dict && dict[@"code"]) {
                //加密后的key
                NSString *entryKey = [HHEncryptionManager encryptWithCode:dict[@"code"] joinCode:k_id];
                [self getNewsList:entryKey type:[self transform:type] idx:idx pgnum:pgnum startkey:startkey newkey:newkey handler:handler];
            }
        } else {
            handler(error,nil);
        }
    }];
    
    
}


+ (void)getNewsList:(NSString *)key
               type:(NSString *)type
                idx:(int)idx
              pgnum:(int)pgnum
           startkey:(NSString *)startkey
             newkey:(NSString *)newkey
            handler:(Block)handler{
    
    NSDictionary *parameters = @{
                                 @"idx":[NSString stringWithFormat:@"%d", idx],
                                 @"type":type,
                                 @"pgnum":[NSString stringWithFormat:@"%d", pgnum],
                                 @"ime":UUID,
                                 @"key":key,
                                 @"startkey":startkey ?: @"",
                                 @"newkey":newkey ?: @"",
                                 @"apptypeid":k_qid,
                                 @"appver":APP_VER,
                                 @"qid":k_qid
                                 };
    
    [HHNetworkManager postRequestWithUrl:k_newspool_url parameters:parameters isEncryptedJson:NO otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            [self formatRespondsStr:respondsStr handler:handler];
        } else {
            handler(error,nil);
        }
    }];
    
    
}

+ (void)formatRespondsStr:(NSString *)respondsStr
                  handler:(Block)handler{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSDictionary *responds = [respondsStr mj_JSONObject];
    if (responds && [responds[@"stat"] isEqual:@1]) {
        NSArray *data = responds[@"data"];
        startkey = responds[@"endkey"];
        newkey = responds[@"newkey"];
       
        pageSize = (int)data.count ?: 0;
        for (NSDictionary *dict in data) {
            HHNewsModel *model = [HHNewsModel mj_objectWithKeyValues:dict];
            [dataArray addObject:model];
            
        }
        
    } else {
        //repeat
        
    }
    handler(nil, dataArray.copy);
}

//头条 -> toutiao
+ (NSString *)transform:(NSString *)chinese{
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    pinyin = [[pinyin lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""].copy;
    return pinyin;
    
}

#pragma mark TopNews

+ (void)requestForTopNews:(Block)callback {
    
    NSDictionary *parameters = @{
                                 @"channel":@"htt",
                                 @"position":@1
                                 };
    [HHNetworkManager postRequestWithUrl:k_topnews_url parameters:parameters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            Log(error);
            callback(error, nil);
        } else {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            if (dict && [dict[@"statusCode"] isEqual:@200]) {
                
                NSMutableArray *callbackArr = [NSMutableArray array];
                NSArray *topnews = dict[@"results"];
                for (NSDictionary *modeldic in topnews) {
                    HHTopNewsModel *model = [HHTopNewsModel mj_objectWithKeyValues:modeldic];
                    [callbackArr addObject:model];
                }
                callback(nil,callbackArr.copy);
                
            }
        }
        
    }];
}

#pragma mark adList


+ (void)requestForBannerAdList:(Block)callback {
    
    [self requestForAdPositions:^(NSError *error, id result) {
        if (error) {
            callback(error,nil);
        } else {
            HHAdStrategy *adStrategy = [AdStrategyManager  sharedInstance].shortedAdStrategey;
            if (!adStrategy) {
                callback(nil, @[]);
            } else {
                [self requestAdListsWithAdStrategy:result isBannel:YES callback:callback];
            }
        }
    } isBanner:YES];
    
}

+ (void)requestForAdList:(Block)callback {
    NSLog(@"ad");
    [self requestForAdPositions:^(NSError *error, HHAdStrategy *result) {
        if (error) {
            NSLog(@"---%@",error);
            callback(error,nil);
        } else {
    
            [self requestAdListsWithAdStrategy:result isBannel:NO callback:callback];
            
        }
    } isBanner:NO];
    
}

+ (void)requestForAdPositions:(Block)callback
                     isBanner:(BOOL)isBanner {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double place = time - AdStrategyManager.sharedInstance.lastTime;
    
    if ([AdStrategyManager sharedInstance].adStrategey && place < 60 * 30) {
       
        callback(nil, [AdStrategyManager sharedInstance].shortedAdStrategey);
        return;
    }
    AdStrategyManager.sharedInstance.lastTime = time;
    NSString *url = isBanner ? k_getBannerAdStrategy : k_getAdStrategy;
    
    [HHNetworkManager postRequestWithUrl:url parameters:nil isEncryptedJson:NO otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            Log(error);
            callback(error,nil);
        } else {
            NSDictionary *ad = [respondsStr mj_JSONObject];
            HHAdStrategy *adStrategy = [HHAdStrategy mj_objectWithKeyValues:ad];
            if (isBanner) {
                callback(nil, adStrategy);
            } else {
                [AdStrategyManager sharedInstance].adStrategey = adStrategy;
                HHAdStrategy *shortedStrategey = [AdStrategyManager sharedInstance].shortedAdStrategey;
                //返回排序后的strategey
                callback(nil,shortedStrategey);
            }
        }
    }];
    
}

+ (void)requestAdListsWithAdStrategy:(HHAdStrategy *)adStrategy
                            isBannel:(BOOL)isBannel
                            callback:(Block)callback {
    
    NSMutableArray *ads = adStrategy.adPositions.mutableCopy; //用replaceObjectAtIndex来保证顺序
    NSMutableArray *resultModels = [NSMutableArray array];
    
    if (ads.count == 1) {
        HHAdRequest *ad = [[HHAdRequest alloc] init];
        ad.appVersion = APP_VER;
        ad.planId = @"";
        ad.adPosition = ads[0];
        NSDictionary *parameters = [ad mj_JSONObject];
        [self requestForAdWithUrl:k_ad_list_url parameters:parameters callback:^(NSError *error, id result) {
            if (error) {
                Log(error);
                NSLog(@"%@广告请求error", adStrategy.adPositions[0].channel);
                callback(error,nil);
                return ;
            }
            [ads replaceObjectAtIndex:0 withObject:result ?: @[]];
            
            for (NSArray *array in ads) {
                for (HHAdModel *ad in array) {
                    [resultModels addObject:ad];
                }
            }
            if (!resultModels.count) {
                NSLog(@"广告没有请求到");
            }
            callback(nil, resultModels.copy);
        }];
    } else {
        dispatch_queue_t dispatchQueue = dispatch_queue_create("CASHTOUTIAO.REQUESTAD", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t dispatchGroup = dispatch_group_create();
        
        [adStrategy.adPositions enumerateObjectsUsingBlock:^(AdPosition * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            HHAdRequest *ad = [[HHAdRequest alloc] init];
            ad.appVersion = APP_VER;
            ad.planId = @"";
            ad.adPosition = obj;
            NSDictionary *parameters = [ad mj_JSONObject];
            
            dispatch_group_enter(dispatchGroup);
            dispatch_async(dispatchQueue, ^{
                [self requestForAdWithUrl:k_ad_list_url parameters:parameters callback:^(NSError *error, id result) {
                    if (error) {
                        Log(error);
                        NSLog(@"%@广告请求error", obj.channel);
                    }
                    [ads replaceObjectAtIndex:index withObject:result ?: @[]];
                    dispatch_group_leave(dispatchGroup);
                    
                }];
            });
            
            
        }];
        
        dispatch_group_notify(dispatchGroup, dispatchQueue, ^{
            for (NSArray *array in ads) {
                for (HHAdModel *ad in array) {
                    [resultModels addObject:ad];
                }
            }
            callback(nil, resultModels.copy);
        });
    }
    
}



// 返回 HHAdModel数组
+ (void)requestForAdWithUrl:(NSString *)url
                 parameters:(id)parameters
                   callback:(Block)callback {
    NSMutableArray *ads = [NSMutableArray array];
    [HHNetworkManager postRequestWithUrl:url parameters:parameters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            
            NSArray *dicts = [respondsStr mj_JSONObject];
            for (NSDictionary *dict in dicts) {
                HHAdModel *adModel = [HHAdModel mj_objectWithKeyValues:dict];
                [ads addObject:adModel];
            }
            callback(nil, ads.copy);
        } else {
            callback(error, nil);
        }
    }];
}

+ (void)requestForReadAward:(Block)callback {
    
    [HHNetworkManager postRequestWithUrl:k_readConfig_description_url parameters:nil isEncryptedJson:NO otherArg:@{@"requestType" : @"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            if (dict && dict[@"descList"]) {
                NSArray *arr = dict[@"descList"];
                callback(nil, arr);
            }
        } else {
            callback(error, nil);
        }
        
    }];
}


+ (void)requestForReadIncomeDetail:(Block)callback {
    
    [HHNetworkManager postRequestWithUrl:k_readIncomeDetail_url parameters:nil isEncryptedJson:NO otherArg:@{@"requestType" : @"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            HHReadIncomeDetailResponse *response = [HHReadIncomeDetailResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil, response);
        } else {
            callback(error, nil);
        }
    }];
}

+ (void)sychRewardPerHourWithHour:(int)hour
                         callback:(void(^)(NSError *error,HHAwardPerHourResponse *response))callback{
    NSLog(@"时段奖励请求");
    [HHNetworkManager postRequestWithUrl:k_sync_awardPerhour parameters:nil isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHAwardPerHourResponse *response = [HHAwardPerHourResponse mj_objectWithKeyValues:dict];
            callback(nil,response);
        }
    }];
    
}

+ (void)sychDurationWithDuration:(int)duration
                        callback:(Block)callback {
    
    NSLog(@"同步阅读时长请求:%zd",duration);
    HHReadSychDurationRequest *sychDurationRequest = [[HHReadSychDurationRequest alloc] init];
    sychDurationRequest.duration = duration;
    NSDictionary *paramaters = [sychDurationRequest mj_keyValues];
    [HHNetworkManager postRequestWithUrl:k_sync_duration parameters:paramaters isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            HHReadSychDurationResponse *response = [HHReadSychDurationResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            [HHUserManager sharedInstance].sychDurationResponse = response;
            callback(nil,response);
        } else {
            callback(error, nil);
        }
    }];
    
    
    
}

+ (void)sychVideoDurationWithDuration:(int)duration
                             callback:(void(^)(id error , HHReadSychDurationResponse *response))callback {
    
    NSLog(@"同步视频时长请求:%zd",duration);
    HHReadSychDurationRequest *sychDurationRequest = [[HHReadSychDurationRequest alloc] init];
    sychDurationRequest.duration = duration;
    sychDurationRequest.channel = @"360";
    NSDictionary *paramaters = [sychDurationRequest mj_keyValues];
    [HHNetworkManager postRequestWithUrl:k_sync_duration parameters:paramaters isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        if (respondsStr) {
            HHReadSychDurationResponse *response = [HHReadSychDurationResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            [HHUserManager sharedInstance].sychDurationResponse = response;
            callback(nil,response);
        } else {
            callback(error, nil);
        }
    }];
    
}

+ (void)sychListAdExposureWithMap:(NSDictionary<NSString *,NSNumber *> *)map
                         callback:(void(^)(id error, HHResponse *response))callback
{
    
    
    [HHNetworkManager postRequestWithUrl:k_sych_ad_exposure parameters:@{@"sychMap":map} isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
       
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }

    }];
}

@end

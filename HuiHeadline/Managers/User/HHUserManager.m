//
//  HHUserManager.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHUserManager.h"



static HHUserManager *userManager = nil;

@implementation HHUserManager

@synthesize currentUser = _currentUser;
@synthesize userName = _userName;
@synthesize passWord = _passWord;
@synthesize channels = _channels;
@synthesize video_channels = _video_channels;
@synthesize readConfig = _readConfig;
@synthesize sychDurationResponse = _sychDurationResponse;
@synthesize readTime = _readTime;
@synthesize lastPerHourAwardTime = _lastPerHourAwardTime;
@synthesize creditSummary = _creditSummary;


+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[HHUserManager alloc] init];
    });
    return userManager;
}

- (void)setUserName:(NSString *)userName {
    
    _userName = userName;
    [self saveWithKey:@"USER_NAME" object:userName];
}

- (NSString *)userName {
    _userName = [self objectForKeyInUserDefaults:@"USER_NAME"];
    
    return _userName;
}

- (void)setPassWord:(NSString *)passWord {
    _passWord = passWord;
    [self saveWithKey:@"PASS_WORD" object:passWord];
}

- (NSString *)passWord {
    _passWord = [self objectForKeyInUserDefaults:@"PASS_WORD"];
    return _passWord;
}

#pragma mark currentUser

///退出登录清空

- (void)setCurrentUser:(HHUserModel *)currentUser {
    
    if (!currentUser) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CURRENT_USER"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    _currentUser = currentUser;
    [self saveWithKey:@"CURRENT_USER" object:[_currentUser mj_JSONObject]];
    
}

- (HHUserModel *)currentUser {
    NSDictionary *user_dict = [self objectForKeyInUserDefaults:@"CURRENT_USER"];
    if (!user_dict) {
        return nil;
    }
    _currentUser = [HHUserModel mj_objectWithKeyValues:user_dict];
    return _currentUser;
}


#pragma  mark lastPerHourAwardTime


- (void)setLastPerHourAwardTime:(int)lastPerHourAwardTime {
    
    if (_lastPerHourAwardTime && _lastPerHourAwardTime == lastPerHourAwardTime) {
        return;
    }
    [self saveToUserDefaultsWithKey:@"AWARD_PER_HOUR" object:[NSNumber numberWithInt:lastPerHourAwardTime]];
}

- (int)lastPerHourAwardTime {
    
    return [[self objectForBindedKeyInUserDefaults:@"AWARD_PER_HOUR"] intValue];
}



#pragma mark user

- (long)userId {
    if (self.currentUser && self.currentUser.userInfo) {
        return self.currentUser.userInfo.user_id;
    }
    return 0;
}

- (NSString *)loginId {
    if (self.currentUser && self.currentUser.loginId) {
        return self.currentUser.loginId;
    }
    return nil;
    
}


#pragma mark readConfig



- (void)setReadConfig:(HHReadConfigResponse *)readConfig {
    
    if (_readConfig && [[_readConfig mj_keyValues] isEqualToDictionary:[readConfig mj_keyValues]]) {
        return;
    }
    _readConfig = readConfig;
    [self saveToUserDefaultsWithKey:@"READCONFIG" object:[readConfig mj_keyValues]];
}

- (HHReadConfigResponse *)readConfig {
    
    
    NSDictionary *readConfigDict = [self objectForBindedKeyInUserDefaults:@"READCONFIG"];
    _readConfig = [HHReadConfigResponse mj_objectWithKeyValues:readConfigDict];
    return _readConfig;
}

#pragma mark creditSummary

- (void)setCreditSummary:(HHUserCreditSummary *)creditSummary {
    if (_creditSummary && [[_creditSummary mj_keyValues] isEqualToDictionary:[creditSummary mj_keyValues]]) {
        return;
    }
    _creditSummary = creditSummary;
    [self saveToUserDefaultsWithKey:@"CREDITSUMMARY" object:[creditSummary mj_keyValues]];
    
}

- (HHUserCreditSummary *)creditSummary {
  
    _creditSummary = [HHUserCreditSummary mj_objectWithKeyValues:[self objectForBindedKeyInUserDefaults:@"CREDITSUMMARY"]];
    return _creditSummary;
    
}

#pragma mark sychDurationResponse

- (void)setSychDurationResponse:(HHReadSychDurationResponse *)sychDurationResponse{
    
    if (_sychDurationResponse && [[_sychDurationResponse mj_keyValues] isEqualToDictionary:[sychDurationResponse mj_keyValues]]) {
        return;
    }
    _sychDurationResponse = sychDurationResponse;
    [self saveToUserDefaultsWithKey:@"SYCHDURATIONRESPONSE" object:[sychDurationResponse mj_keyValues]];
}

- (HHReadSychDurationResponse *)sychDurationResponse {
    
    
    NSDictionary *dict = [self objectForBindedKeyInUserDefaults:@"SYCHDURATIONRESPONSE"];
    _sychDurationResponse = [HHReadSychDurationResponse mj_objectWithKeyValues:dict];
    
    return _sychDurationResponse;
}





#pragma mark channels

- (void)setChannels:(NSMutableArray<NSString *> *)channels {
    if (_channels && [_channels isEqualToArray:channels]) {
        return;
    }
    _channels = channels;
    [self saveToUserDefaultsWithKey:@"NEWS_CHANNELS" object:channels];

}

- (NSMutableArray<NSString *> *)channels {
    
    _channels = [self objectForBindedKeyInUserDefaults:@"NEWS_CHANNELS"];
    if (!_channels) {
        _channels = k_default_channel.mutableCopy;
    }
    return _channels;
}

- (NSMutableArray<NSString *> *)allChannels {
    
    if (!_allChannels) {
        _allChannels = k_all_channel.mutableCopy;
    }
    return _allChannels;
    
}

- (void)setVideo_channels:(NSMutableArray<NSString *> *)video_channels {
   
    if (_video_channels && [_video_channels isEqualToArray:video_channels]) {
        return;
    }
    _video_channels = video_channels;
    [self saveToUserDefaultsWithKey:@"VIDEO_CHANNELS" object:video_channels];
    
}

- (NSMutableArray<NSString *> *)video_channels {
    
    _video_channels = [self objectForBindedKeyInUserDefaults:@"VIDEO_CHANNELS"];
    if (!_video_channels) {
        _video_channels = k_default_videos.mutableCopy;
    }
    return _video_channels;
}

- (NSMutableArray<NSString *> *)vodeo_allChannels {
    
    if (!_vodeo_allChannels) {
        _vodeo_allChannels = k_all_videos.mutableCopy;
    }
    return _vodeo_allChannels;
    
}

#pragma mark Util

- (NSString * _Nonnull)bindKey:(NSString *)key {
    return [NSString stringWithFormat:@"%ld_%@",_currentUser.userInfo.user_id, key];
}

- (void)saveWithKey:(NSString *)key
             object:(id)object
{
    [NSUserDefaults.standardUserDefaults setObject:object forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}


- (id)objectForKeyInUserDefaults:(NSString *)key {
    
    return  [NSUserDefaults.standardUserDefaults objectForKey:key];
}

///bind user
- (void)saveToUserDefaultsWithKey:(NSString *)key
                           object:(id)object
{
    [NSUserDefaults.standardUserDefaults setObject:object forKey:[self bindKey:key]];
    [NSUserDefaults.standardUserDefaults synchronize];
}
///bind user
- (id)objectForBindedKeyInUserDefaults:(NSString *)key {
    
    return  [NSUserDefaults.standardUserDefaults objectForKey:[self bindKey:key]];
}


@end

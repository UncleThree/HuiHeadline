//
//  HHUserInfo.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 long id;
 
 String nickName;
 
 String phone;
 
 String headPortrait;
 
 Short gender;
 
 String city;
 
 String briefIntroduction;
 
 String birthday;
 
 int state;
 
 Date registerTime;
 */

@interface HHUserCity : NSObject

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;


@end

@interface HHUserInfo : NSObject

@property (nonatomic, assign) long user_id;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *phone_sec;
//头像
@property (nonatomic, copy) NSString *headPortrait;
//1男2女
@property (nonatomic, assign) short gender;
@property (nonatomic, copy) NSString *genderString;
@property (nonatomic, strong) HHUserCity *city;
@property (nonatomic, copy) NSString *briefIntroduction;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign)int state;
@property (nonatomic, assign)long registerTime;
@property (nonatomic, copy) NSString *recommendedCode;

///2017-11-15号之前注册的账户不显示新手任务
@property (nonatomic, assign)BOOL isNew;

@end

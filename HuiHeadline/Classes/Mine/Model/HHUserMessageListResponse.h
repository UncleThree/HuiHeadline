//
//  HHUserMessageListResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHResponse.h"

typedef enum : NSUInteger {
    UserMessageTypeSystemAnnouncement = 0,
    UserMessageTypeActivityAnnouncement  ,
    UserMessageTypeCommonAnnouncement ,
    UserMessageTypeUpdateAnnouncement ,
    UserMessageTypeImportantAnnouncement
} UserMessageType;

@interface HHUserMessage : NSObject

@property (nonatomic, assign)NSInteger message_id;

@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong)NSString *picture;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *url;

@property (nonatomic, assign)NSInteger createTime;

@property (nonatomic, assign)UserMessageType type;

@property (nonatomic, assign)NSInteger userId;

- (CGFloat)heightForMessage;


@end

@interface HHUserMessageListResponse : HHResponse

@property (nonatomic, strong)NSArray<HHUserMessage *> *userMessageList;

@property (nonatomic, assign)NSInteger criticalValue;

@end



//
//  HHInvitedJsonModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHInvitedItem : NSObject

@property (nonatomic, copy)NSString *imgUrl;

@property (nonatomic, copy)NSString *targetLinkUrl;

@end

@interface HHInvitedJsonModel : NSObject

@property (nonatomic, strong)NSArray<HHInvitedItem *> *bottomItems;

@property (nonatomic, strong)NSArray<HHInvitedItem *> *ruleItems;

@property (nonatomic, strong)HHInvitedItem *headerItem;

@end

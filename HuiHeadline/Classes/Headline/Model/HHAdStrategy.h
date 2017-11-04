//
//  HHAdStrategy.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/29.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AdPosition : NSObject

@property (nonatomic, copy)NSString *channel;
@property (nonatomic, copy)NSString *appId;
@property (nonatomic, copy)NSString *positionId;
@property (nonatomic, copy)NSString *mode;
@property (nonatomic, assign)int adCount;

@end

@interface HHAdStrategy : NSObject


@property (nonatomic, strong)NSArray<AdPosition *> *adPositions;
@property (nonatomic, strong)NSMutableArray<NSNumber *> *ratios;

@end




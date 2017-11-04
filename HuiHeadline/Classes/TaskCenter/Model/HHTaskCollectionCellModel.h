//
//  HHTaskCollectionCellModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HHTaskCollectionCellSigned = 0,
    HHTaskCollectionCellToday,
    HHTaskCollectionCellNormal,
} HHTaskCollectionCellType;

@interface HHTaskCollectionCellModel : NSObject

@property (nonatomic, assign)HHTaskCollectionCellType type;

@property (nonatomic, copy)NSString *coin;

@property (nonatomic, copy)NSString *day;


@end

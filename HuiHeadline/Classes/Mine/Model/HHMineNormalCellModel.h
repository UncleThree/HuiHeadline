//
//  HHMineNormalCellModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHMineNormalCellModel : NSObject

@property (nonatomic, copy)NSString *imgName;

@property (nonatomic, copy)NSString *text;

@property (nonatomic)BOOL hasNew;
@property (nonatomic, copy)NSString *redText;


@property (nonatomic)BOOL hasSub;
@property (nonatomic, copy)NSString *subText;
@property (nonatomic, copy)NSString *subImageName;


@end

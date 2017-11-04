//
//  HHInvitedJsonModel.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHInvitedJsonModel.h"

@implementation HHInvitedItem

@end

@implementation HHInvitedJsonModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"bottomItems":@"HHInvitedItem"
             };
}

- (NSArray<HHInvitedItem *> *)ruleItems {
    if (_bottomItems.count == 3) {
        _ruleItems = _bottomItems.copy;
    } else if (_bottomItems.count == 4) {
        _ruleItems = @[_bottomItems[1], _bottomItems[2], _bottomItems[3]];
    }
    return _ruleItems;
}

@end



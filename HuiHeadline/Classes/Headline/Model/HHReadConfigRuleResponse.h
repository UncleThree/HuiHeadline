//
//  HHReadConfigRuleResponse.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/11.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHReadConfigRuleResponse : NSObject

//
@property (nonatomic, strong)NSMutableArray<NSString *>   *listPageIdenfierList;

@property (nonatomic, strong)NSMutableArray<NSString *> *detailPageIdenfierList;

@property (nonatomic, strong)NSMutableArray<NSString *> *adTransitionPageIdenfierList;

@end

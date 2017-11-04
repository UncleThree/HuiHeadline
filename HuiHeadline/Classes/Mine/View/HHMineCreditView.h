//
//  HHMineCreditView.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCreditSummaryResponse.h"

@interface HHMineCreditView : UIView

- (instancetype)initWithFrame:(CGRect)frame summary:(HHUserCreditSummary *)summary;

@end

@interface HHMineCreditLabelView : UIView

- (instancetype)initWithFrame:(CGRect)frame text1:(NSString *)text1 text2:(NSString *)text2;

@end

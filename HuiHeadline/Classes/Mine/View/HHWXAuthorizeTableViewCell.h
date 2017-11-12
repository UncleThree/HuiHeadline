//
//  HHWXAuthorizeTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/6.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHWXAuthorizeModel : NSObject

@property (nonatomic, copy)NSString *labelText;

@property (nonatomic, assign)BOOL authorized;

@property (nonatomic, copy)NSString *wxName;

@property (nonatomic, copy)NSString *headerUrl;

@property (nonatomic, assign)BOOL enabled;

@end

@interface HHWXAuthorizeTableViewCell : UITableViewCell

@property (nonatomic, strong)HHWXAuthorizeModel *model;

@end

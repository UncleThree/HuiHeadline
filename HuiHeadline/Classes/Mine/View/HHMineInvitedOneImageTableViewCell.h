//
//  HHMineInvitedOneImageTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/7.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHMineInvitedImageTableViewCellDelegate <NSObject>

@optional
- (void)invitedCellFillCode;

- (void)invitedCellstNow;

@required
- (void)clickBanner:(NSString *)link;

@end

@interface HHMineInvitedOneImageTableViewCell : UITableViewCell


@property (nonatomic, weak)id <HHMineInvitedImageTableViewCellDelegate> delegate;

@property (nonatomic, strong)HHInvitedItem  *model;

@property (nonatomic, assign)BOOL beInvited;

@end

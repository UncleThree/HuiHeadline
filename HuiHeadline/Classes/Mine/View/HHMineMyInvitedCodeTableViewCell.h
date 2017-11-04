//
//  HHMineMyInvitedCodeTableViewCell.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyInVitedCodeCellDelegate <NSObject>

- (void)clickQRCode:(UIImage *)image;

- (void)clickCopy:(NSString *)code;

@end

@interface HHMineMyInvitedCodeTableViewCell : UITableViewCell

@property (nonatomic, weak)id<MyInVitedCodeCellDelegate>delegate;

@property (nonatomic, copy)NSString *invitedCode;

@end

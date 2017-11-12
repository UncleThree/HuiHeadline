//
//  HHMineSettingTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineSettingTableViewCell.h"


@interface HHMineSettingTableViewCell ()

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)UIImageView *headImageView;

@property (nonatomic, strong)UILabel *subLabel;

@property (nonatomic, strong)UIImageView *nextImageView;

@end

@implementation HHMineSettingTableViewCell

#define cell_height 55

#define cell_header_height 75

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}

- (void)initUI {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, KWIDTH / 2, 20)];
    self.label.font = Font(17);
    self.label.textColor = BLACK_51;
    self.label.center = CGPointMake(self.label.center.x, cell_height/ 2);
    [self.contentView addSubview:self.label];
    
    CGFloat nextWidth = 8;
    UIImage *image = [UIImage imageNamed:@"next"];
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 12 - nextWidth, 0, nextWidth, image.size.height / image.size.width * nextWidth)];
    self.nextImageView.image = image;
    self.nextImageView.center = CGPointMake(self.nextImageView.center.x, cell_height / 2);
    [self.contentView addSubview:self.nextImageView];
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWIDTH / 2, 0, KWIDTH / 2 - 12 - 12 - nextWidth, 30)];
    self.subLabel.center = CGPointMake(self.subLabel.center.x, cell_height / 2);
    self.subLabel.font = Font(15);
    self.subLabel.textColor = BLACK_153;
    self.subLabel.textAlignment = 2;
    [self.contentView addSubview:self.subLabel];
    
    
    
}

- (void)setModel:(HHMineSettingCellModel *)model {
    
    self.label.text = model.text;
    if ([self.label.text isEqualToString:@"退出登录"]) {
        
        self.label.textColor = RGB(255, 64, 59);
        
    } else {
        self.label.textColor = BLACK_51;
    }
    
    if (!model.imageUrl) {
        
        
        if (model.subText) {
            self.subLabel.text = model.subText;
            self.subLabel.textColor = BLACK_153;
        } else if ([model.text isEqualToString:@"手机号"]) {
            
            self.subLabel.text = @"未绑定";
            self.subLabel.textColor = RGB(255, 108, 0);
        } else {
            self.subLabel.text = @"未设置";
            self.subLabel.textColor = RGB(255, 108, 0);
        }
        

        
    } else {
        
        [self initHeaderView];
        [self.headImageView sd_setImageWithURL:URL(model.imageUrl) placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
        
        
    }
   
    
    
}

- (void)initHeaderView {
    
    self.subLabel.hidden = YES;
    self.label.center = CGPointMake(self.label.center.x, cell_header_height / 2);
    self.nextImageView.center = CGPointMake(self.nextImageView.center.x, cell_header_height / 2);

    
    CGFloat width = 45;
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake( X(self.nextImageView) - 12 - width , 0, width, width)];
    self.headImageView.center = CGPointMake(self.headImageView.center.x, cell_header_height / 2);
    self.headImageView.layer.cornerRadius = width / 2;
    self.headImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headImageView];
}




@end

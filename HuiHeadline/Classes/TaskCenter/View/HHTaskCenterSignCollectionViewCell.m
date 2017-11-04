//
//  HHTaskCenterSignCollectionViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskCenterSignCollectionViewCell.h"

@interface HHTaskCenterSignCollectionViewCell ()

@property (nonatomic, strong)UIImageView *imgView;

@property (nonatomic, strong)UILabel *coinsLabel;

@property (nonatomic, strong)UILabel *dayLabel;

@end

@implementation HHTaskCenterSignCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI:frame];
    }
    return self;
}


- (void)initUI:(CGRect)frame {
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    self.imgView.layer.cornerRadius = frame.size.width / 2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0.5;
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.contentView addSubview:self.imgView];
    
    CGFloat scale = 0.52;
    CGFloat imgHeight = frame.size.width;
    self.coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgHeight * scale, imgHeight, 20)];
    self.coinsLabel.font = Font(11);
    self.coinsLabel.textAlignment = 1;
    [self.contentView addSubview:self.coinsLabel];
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.imgView) + 8, imgHeight, 20)];
    self.dayLabel.textAlignment = 1;
    self.dayLabel.font = Font(12);
    [self.contentView addSubview:self.dayLabel];
    
    
}

- (void)setModel:(HHTaskCollectionCellModel *)model {
    
    NSArray *imgArray = @[@"task_has_been_receive",@"task_can_receive",@"task_sign"];
    self.imgView.image = [UIImage imageNamed:imgArray[model.type]];
    
    self.coinsLabel.text = [NSString stringWithFormat:@"+%@", model.coin];
    self.coinsLabel.textColor = model.type == 0 ? BLACK_153 : [UIColor whiteColor];
    
    self.dayLabel.text = model.day;
    self.dayLabel.textColor = model.type == 0 ? RGB(218, 218, 218) : [UIColor whiteColor];
    
}


@end

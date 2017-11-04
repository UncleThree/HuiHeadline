//
//  HHTaskTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/25.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHTaskTableViewCell.h"

@interface HHTaskTableViewCell ()

@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIButton *button;

@end

@implementation HHTaskTableViewCell

#define HEIGHT 50
#define NEWBIETAG 1000
#define DAILYTAG 2000

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.contentView.backgroundColor = RGB(242, 242, 242);
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 0.5, HEIGHT)];
    self.line.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:self.line];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.line) + 12, 0, KWIDTH / 2, HEIGHT)];
    self.titleLabel.font = Font(15);
    self.titleLabel.textColor = RGB(102, 102, 102);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat width = 65;
    CGFloat height = 55 / 2.0;
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(KWIDTH - 12 - 15 -12 - width, (HEIGHT - height) / 2, width, height)];
    self.button.layer.cornerRadius = 5;
    self.button.tintColor = [UIColor whiteColor];
    self.button.titleLabel.font = Font(14);
    [self.contentView addSubview:self.button];
    
    
}

- (void)setModel:(HHTaskCellModel *)model {
    
    _model = model;
    self.contentView.frame = CGRectMake(0, 0, KWIDTH, [model heightForModel]);
    self.titleLabel.hidden = !model.show;
    self.line.hidden = !model.show;
    self.button.hidden = !model.show;
    
    if (!model.show) {
        return;
    }
    self.titleLabel.text = model.title;
    self.titleLabel.frame = CGRectMake(X(self.line) + 13, 0, KWIDTH - X(self.line) - 13 - 105 - 12, [model heightForModel]);
    
    [self.button setTitle:model.subText forState:(UIControlStateNormal)];
    self.button.center = CGPointMake(self.button.center.x, [model heightForModel] / 2);
    if (model.state == 0) {
        self.button.backgroundColor = HUIRED;
    } else if (model.state == 1) {
        self.button.backgroundColor = RGB(255, 153, 0);
    } else {
        self.button.backgroundColor = RGB(182, 182, 182);
    }
    [self.button addTarget:self action:@selector(buttonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)buttonClickAction:(UIButton *)button {
    
    BOOL isNewbie = self.model.taskId > 0;
    NSInteger taskId = isNewbie ? self.model.taskId : self.model.dailyTaskId;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskTableViewCellDidClickTaskId:isNewbie:title:)]) {
        [self.delegate taskTableViewCellDidClickTaskId:taskId isNewbie:isNewbie title:button.currentTitle];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityTaskTitle:url:)] && !isNewbie && taskId != 101) {
        ///activityTask
        [self.delegate activityTaskTitle:self.model.activityTitle url:self.model.url];
        
    }

    
}


@end

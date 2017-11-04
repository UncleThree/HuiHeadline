//
//  HHHeadlineReadAwardTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/11.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineReadAwardTableViewCell.h"

@interface HHHeadlineReadAwardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firLabel;

@property (weak, nonatomic) IBOutlet UILabel *secLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;


@end

@implementation HHHeadlineReadAwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    self.redView.backgroundColor = HUIRED;
    self.titleLabel.font = Font(19);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.firLabel.backgroundColor = [UIColor whiteColor];
    self.secLabel.backgroundColor = [UIColor whiteColor];
    self.thirdLabel.backgroundColor = [UIColor whiteColor];
    
    
    self.redView.layer.borderWidth = 1;
    self.redView.layer.borderColor = RGB(224, 224, 224).CGColor;
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = RGB(224, 224, 224).CGColor;
    
}

- (void)setModel:(HHReadIncomDetailRecord *)model {
    int day = [HHDateUtil paseDays:model.day];
    NSArray *imgArray = @[@"今",@"昨天",@"前日"];
    NSArray *textArray = @[@"今日数据",@"昨日数据",@"前日数据"];
    if (day < 0 || day >2) return;
    
    self.redView.backgroundColor = day == 0 ? HUIRED : [UIColor whiteColor];
    self.titleLabel.textColor = day == 0 ? [UIColor whiteColor] :BLACK_51;
    
    self.imgV.image = [UIImage imageNamed:imgArray[day]];
    self.titleLabel.text = textArray[day];
    [self setAttribute:model day:day];
    
    
}

- (void)setAttribute:(HHReadIncomDetailRecord *)model
                 day:(int)day{
    
    UIColor *blueColor = RGB(43, 129, 248);
    
    NSString *firText = [NSString stringWithFormat:@"阅读时长%@，获得%d金币",[self getMinutesString:model.duration], model.durationCredit];
    NSMutableAttributedString *firAttr = [[NSMutableAttributedString alloc] initWithString:firText attributes:@{KEY_FONT : Font(14.5), KEY_COLOR : day == 0 ? blueColor : BLACK_51}];
    [firAttr addAttributes:@{KEY_COLOR:BLACK_51} range:[firText rangeOfString:@"阅读时长"]];
    [firAttr addAttributes:@{KEY_COLOR:BLACK_51} range:[firText rangeOfString:@"，获得"]];
    self.firLabel.attributedText = firAttr.copy;
    
    NSString *secText = [NSString stringWithFormat:@"分享点击%d次，获得%d金币",model.shareClick, model.shareClickCredit];
    NSMutableAttributedString *secAttr = [[NSMutableAttributedString alloc] initWithString:secText attributes:@{KEY_FONT : Font(14.5), KEY_COLOR : day == 0 ? blueColor : BLACK_51}];
    [secAttr addAttributes:@{KEY_COLOR:BLACK_51} range:[secText rangeOfString:@"分享点击"]];
    [secAttr addAttributes:@{KEY_COLOR:BLACK_51} range:[secText rangeOfString:@"，获得"]];
    self.secLabel.attributedText = secAttr.copy;
    
    NSString *thirText = [NSString stringWithFormat:@"任务奖励收益，实际获得%d金币", model.taskCredit];
    NSMutableAttributedString *thirAttr = [[NSMutableAttributedString alloc] initWithString:thirText attributes:@{KEY_FONT : Font(14.5), KEY_COLOR : day == 0 ? blueColor : BLACK_51}];
    [thirAttr addAttributes:@{KEY_COLOR:BLACK_51} range:[thirText rangeOfString:@"任务奖励收益，实际获得"]];
    self.thirdLabel.attributedText = thirAttr.copy;
    
    self.firLabel.hidden = model.durationCredit == 0;
    self.secLabel.hidden = model.shareClickCredit == 0;
    self.thirdLabel.hidden = model.taskCredit == 0;
    
}



- (NSString *)getMinutesString:(int)seconds {
    
    NSString *result = @"";
    int second = seconds % 60;
    if (second != 0) {
        result = [NSString stringWithFormat:@"%zd秒",second];
    }
    int minute = (seconds / 60) % 60;
    if (minute != 0) {
        result = [[NSString stringWithFormat:@"%zd分钟",minute] stringByAppendingString:result];
    }
    int hour = seconds / 3600;
    if (hour > 0) {
        result = [[NSString stringWithFormat:@"%d小时",hour] stringByAppendingString:result];
    }
    if ([result isEqualToString:@""]) {
        return @"0秒";
    }
    return result;

}


@end

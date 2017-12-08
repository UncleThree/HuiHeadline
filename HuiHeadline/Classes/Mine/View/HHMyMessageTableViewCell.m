//
//  HHMyMessageTableViewCell.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/11/21.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMyMessageTableViewCell.h"

@interface HHMyMessageTableViewCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *littleLabel;

@property (nonatomic, strong)UIImageView *imgV;

@property (nonatomic, strong)UILabel *tLabel;

@property (nonatomic, strong)UILabel *dLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *line;

@property (nonatomic, strong)UILabel *bottomLabel;

@property (nonatomic, strong)UIImageView *next;

@end

@implementation HHMyMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.littleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.littleLabel];
    self.littleLabel.font = Font(14);
    self.littleLabel.textAlignment = 1;
    self.littleLabel.textColor = [UIColor whiteColor];
    
    self.tLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.tLabel];
    self.tLabel.font = kTitleFont;
    self.tLabel.textColor = BLACK_51;
    self.tLabel.numberOfLines = 0;
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = kSubtitleFont;
    self.timeLabel.textColor = BLACK_153;
    [self.contentView addSubview:self.timeLabel];
    
    self.imgV = [[UIImageView alloc] init];
    self.imgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imgV];
    
    self.dLabel = [[UILabel alloc] init];
    self.dLabel.numberOfLines = 0;
    self.dLabel.font = kSubtitleFont;
    self.dLabel.textColor = BLACK_153;
    [self.contentView addSubview:self.dLabel];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = SEPRATE_COLOR;
    [self.contentView addSubview:self.line];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.text = @"立即查看";
    self.bottomLabel.textColor = BLACK_51;
    self.bottomLabel.font = K_Font(16);
    [self.contentView addSubview:self.bottomLabel];
    
    self.next = [[UIImageView alloc] init];
    self.next.image = [UIImage imageNamed:@"next"];
    [self.contentView addSubview:self.next];
    
}


- (void)setType:(NSInteger )type {
    
    switch (type) {
        case UserMessageTypeSystemAnnouncement: {
            self.littleLabel.text = @"系统";
            self.littleLabel.backgroundColor = HUIRED;
            break;
        }
        case UserMessageTypeActivityAnnouncement: {
            self.littleLabel.text = @"活动";
            self.littleLabel.backgroundColor = [UIColor colorWithHexString:@"#fac96a"];
            self.bottomLabel.text = @"立即参与";
            break;
        }
        case UserMessageTypeCommonAnnouncement: {
            self.littleLabel.text = @"公告";
            self.littleLabel.backgroundColor = [UIColor colorWithHexString:@"#a9d788"];
            break;
        }
        case UserMessageTypeUpdateAnnouncement: {
            self.littleLabel.text = @"更新";
            self.littleLabel.backgroundColor = [UIColor colorWithHexString:@"#7dbdfd"];
            break;
        }
        case UserMessageTypeImportantAnnouncement: {
            self.littleLabel.text = @"重要";
            self.littleLabel.backgroundColor = HUIRED;
            break;
        }
            
            
            
    }
}

- (void)layout:(HHUserMessage *)message {
    CGFloat pad = 15;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, pad, 0, pad));
    }];
    CGFloat littlePad = 10;
    CGFloat littleLabelW = 40;
    [self.littleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(littlePad);
        make.top.equalTo(self.contentView).with.offset(pad);
        make.width.mas_equalTo(littleLabelW);
        make.height.mas_equalTo(22);
    }];
    CGFloat height = [HHFontManager sizeWithText:message.title font:kTitleFont maxSize:CGSizeMake(KWIDTH - pad * 2 - littlePad * 2 - 5 - littleLabelW, CGFLOAT_MAX)].height;
    [self.tLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.littleLabel.mas_right).with.offset(5);
        make.top.equalTo(self.littleLabel);
        make.right.equalTo(self.backView).with.offset(-littlePad);
        make.height.mas_equalTo(height + 1);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.littleLabel);
        make.top.equalTo(self.tLabel.mas_bottom).with.offset(15);
        make.right.equalTo(self.backView).with.offset(-littlePad);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat imageHeight = 450 / 936.0 * (KWIDTH - pad * 2 - littlePad * 2) ;
    [self.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(15);
        make.left.right.equalTo(self.timeLabel);
        make.height.mas_equalTo(message.picture ? imageHeight : 0);
    }];
    CGSize size = CGSizeMake(KWIDTH - pad * 2 - littlePad * 2, CGFLOAT_MAX);
    CGFloat dHeight =  [HHFontManager sizeWithAttributeText:self.dLabel.attributedText maxSize:size].height + 1;
    [self.dLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imgV);
        make.top.equalTo(message.picture ? self.imgV.mas_bottom : self.timeLabel.mas_bottom ).with.offset(15);
        make.height.mas_equalTo(dHeight);
    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(message.content && ![message.content isEqualToString:@""] ? self.dLabel.mas_bottom : (message.picture && ![message.picture isEqualToString:@""] ? self.imgV.mas_bottom : self.timeLabel.mas_bottom)).with.offset(10);
        make.left.right.equalTo(self.timeLabel);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).with.offset(10);
        make.left.equalTo(self.dLabel);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [self.next mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel);
        make.right.equalTo(self.line);
        //
    }];
}

- (void)updateContent:(HHUserMessage *)message {
    self.tLabel.text = message.title;
    self.timeLabel.text = [HHDateUtil ymd:message.createTime];
    [self.imgV sd_setImageWithURL:URL(message.picture)];
    
    if (message.content && ![message.content isEqualToString:@""]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message.content attributes:@{KEY_FONT:K_Font(16), KEY_COLOR:BLACK_153}];
        //NSKernAttributeName : @(0.0f) 字间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message.content length])];
        self.dLabel.attributedText = string;
    } else {
        
        self.dLabel.attributedText = nil;
        
    }
    
    
}

- (void)setMessage:(HHUserMessage *)message {
    
    _message = message;
    
    [self setType:message.type];
    
    [self updateContent:message];
    
    [self layout:message];
    
    
}


@end





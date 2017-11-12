//
//  HHMineUpdateGenderView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/24.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineUpdateGenderView.h"


@implementation HHMineUpdateGenderModel

@end

@interface HHMineUpdateGenderView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHMineUpdateGenderModel *> *array;

@end

@implementation HHMineUpdateGenderView

#define tableViewHeight CGFLOAT(100)


- (NSMutableArray *)array {
    if (!_array) {
        _array = @[].mutableCopy;
    }
    return _array;
}


- (instancetype)initWithFrame:(CGRect)frame
                       gender:(NSString *)gender {
    if (self = [super initWithFrame:frame]) {
        
        [self setGender:gender];
        [self initUI];
    }
    return self;
}

- (void)setGender:(NSString *)gender {
    
    HHMineUpdateGenderModel *model_M = [HHMineUpdateGenderModel new];
    model_M.text = @"男";
    model_M.select = [gender isEqualToString:@"男"];
    [self.array addObject:model_M];
    HHMineUpdateGenderModel *model_W = [HHMineUpdateGenderModel new];
    model_W.text = @"女";
    model_W.select = [gender isEqualToString:@"女"];
    [self.array addObject:model_W];
}

- (void)initUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = TRAN_BLACK;
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGenderView)]];
    [self addSubview:backView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, tableViewHeight) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(tableViewHeight);
    }];
    
    [self.tableView registerClass:[HHMineUpdateGenderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineUpdateGenderTableViewCell class])];
}

- (void)hideGenderView {
    
    self.hidden = YES;
}



#pragma mark UITableViewDataSource


kRemoveCellSeparator

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableViewHeight / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHMineUpdateGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineUpdateGenderTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.array[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self resetSelectIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGender:)]) {
        [self.delegate selectGender:[self.array[indexPath.row] text]];
    }
    
}

- (void)resetSelectIndex:(NSInteger)index {
    
    HHMineUpdateGenderModel *model0 = self.array[0];
    HHMineUpdateGenderModel *model1 = self.array[1];
    model0.select = !index;
    model1.select = index;
    [self.array replaceObjectAtIndex:0 withObject:model0];
    [self.array replaceObjectAtIndex:1 withObject:model1];
    [self.tableView reloadData];
}


@end





@interface HHMineUpdateGenderTableViewCell ()

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *selectImgV;

@end

@implementation HHMineUpdateGenderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100,  tableViewHeight / 2)];
    
    self.label.font = Font(15);
    self.label.textColor = BLACK_51;
    [self.contentView addSubview:self.label];
    
    UIImage *image = [UIImage imageNamed:@"xuanze"];
    CGFloat height = 15;
    CGFloat width = image.size.width / image.size.height * height;
    self.selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH - 12 - width, tableViewHeight / 4 - height / 2, width, height)];
    self.selectImgV.image = image;
    [self.contentView addSubview:self.selectImgV];
    
    
    
}

- (void)setModel:(HHMineUpdateGenderModel *)model {
    
    self.label.text = model.text;
    self.selectImgV.hidden = !model.select;
}

@end

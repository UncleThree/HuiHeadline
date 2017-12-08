//
//  HHHeadlineListReadAwardViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/10.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListReadAwardViewController.h"
#import "HHHeadlineReadAwardFirstTableViewCell.h"
#import "HHHeadlineReadAwardTableViewCell.h"

@interface HHHeadlineListReadAwardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIView *yellowView;
@property (nonatomic, strong)UITableView *yellowTableView;

@property (nonatomic, strong)UITableView *incomeTableView;


@end


@implementation HHHeadlineListReadAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    
    [self request];
    
}

- (void)initNavigation {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:[HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back) text:@"阅读收益"]];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#define yellowCellPad 10.0
- (void)initTableView {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat tableHeight = 0;
    for (int i = 0; i < self.descriptions.count; i++) {
        
        tableHeight += [self heightForCell:self.descriptions[i].text] + yellowCellPad;

    }
    self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, KWIDTH - 12 * 2, tableHeight + 20 + 20)];
    self.yellowView.backgroundColor = RGB(246, 240, 188);
    [self.view addSubview:self.yellowView];
    
    self.yellowTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, W(self.yellowView), tableHeight) style:(UITableViewStylePlain)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = NO;
        [self.yellowView addSubview:tableView];
        tableView;
    });
    self.yellowTableView.backgroundColor = [UIColor clearColor];
    self.yellowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yellowTableView.userInteractionEnabled = NO;
    [self.yellowTableView registerClass:[HHHeadlineReadAwardFirstTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHHeadlineReadAwardFirstTableViewCell class])];
    
    
}

- (void)initIncomeTableView {
    
    self.incomeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStylePlain];
    self.incomeTableView.dataSource = self;
    self.incomeTableView.delegate = self;
    self.incomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.incomeTableView.bounces = NO;
    self.incomeTableView.backgroundColor = [UIColor clearColor];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 20)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.incomeTableView.tableFooterView = footer;
    self.incomeTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.incomeTableView];
    
    [self.incomeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.yellowView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view);
    }];
    
    [self.incomeTableView registerNib:[UINib nibWithNibName:@"HHHeadlineReadAwardTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HHHeadlineReadAwardTableViewCell class])];
}

- (NSMutableArray<HHReadAward *> *)descriptions
{
    if (!_descriptions) {
        _descriptions = [NSMutableArray array];
    }
    return _descriptions;
}



- (void)request {
    
    
    [HHHeadlineNetwork requestForReadAward:^(NSError *error, id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            [self parseResult:result];
            [self initTableView];
            
        } else {
            Log(error);
        }
        [self requestForReadIncome];
    }];
    
}



- (void)requestForReadIncome {
    
    [HHHeadlineNetwork requestForReadIncomeDetail:^(NSError *error, id result) {
        if (error) {
            Log(error);
        } else{
            self.income = result;
            
            [self initIncomeTableView];
        }
    }];
    
}


- (void)parseResult:(id)result {
    NSArray<NSString *> *texts = result;
    for (int i = 0; i < texts.count; i++) {
        if (![texts[i] containsString:@"\n"]) {
            HHReadAward *model = [[HHReadAward alloc] init];
            model.text = texts[i];
            model.hasRedPoint = YES;
            [self.descriptions addObject:model];
        } else {
            NSArray *others = [texts[i] componentsSeparatedByCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@"\n;"]];
            for (int j = 0;j < others.count ;j++) {
                HHReadAward *model = [[HHReadAward alloc] init];
                model.text = others[j];
                model.hasRedPoint = j == 0;
                [self.descriptions addObject:model];
                
            }
        }
    }
}



#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:self.yellowTableView]) {
        return self.descriptions.count;
    }
    return self.income.records.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.yellowTableView]) {
        HHHeadlineReadAwardFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHHeadlineReadAwardFirstTableViewCell class]) forIndexPath:indexPath];
        cell.readAward = self.descriptions[indexPath.section];
        return cell;
    } else {
        
        HHHeadlineReadAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHHeadlineReadAwardTableViewCell class]) forIndexPath:indexPath];
        ///根据时间排序
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pastDay" ascending:YES];
        [self.income.records sortUsingDescriptors:@[descriptor]];

        cell.model = self.income.records[indexPath.section];
    
        return cell;
    }
    
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if ([tableView isEqual:self.incomeTableView]) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W(tableView), 20)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [tableView isEqual:self.incomeTableView] ? 20 : 0.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.yellowTableView]) {
        
        CGFloat height = [self heightForCell:self.descriptions[indexPath.section].text] + yellowCellPad;
        
        return height;
        
    } else {
        
        
        CGFloat height = [self.income.records[indexPath.section] heightForCell];
        return 45 + 20 * 2 + height;
        
        
    }
    
    
    
    
}



- (CGFloat)heightForCell:(NSString *)text {
    
    return [HHFontManager sizeWithText:text font:Font(15) maxSize:CGSizeMake(KWIDTH - 12 * 2 - 12 - 5 - 10, CGFLOAT_MAX)].height;
    
}







@end

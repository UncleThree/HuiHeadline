//
//  HHMineInvitedViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/27.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineInvitedViewController.h"
#import "HHMineInvitedImageTableViewCell.h"
#import "HHMineItemTableViewCell.h"
#import "HHMineMyInvitedCodeTableViewCell.h"
#import "HHMineBigQRCodeView.h"

@interface HHMineInvitedViewController () <UITableViewDataSource, UITableViewDelegate, MyInVitedCodeCellDelegate>

@property (nonatomic, strong)UIView *navigationView;

@property (nonatomic, strong)UIImageView *headerItemView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHMineItemCellModel *> *itemCellModels;

@property (nonatomic, strong)UIView *bigQRView;


@end

@implementation HHMineInvitedViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [HHStatusBarUtil changeStatusBarColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initTableView];
    
    [self requestData];
}

- (void)requestData {
    
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [HHMineNetwork requestInviteJson:^(id error, HHInvitedJsonModel *model) {
        if (error) {
            NSLog(@"%@",error);
        }
        [HHMineNetwork requestInviteFetchSummary:^(id error, HHInvitedFetchSummaryResponse *response) {
            if (error) {
                NSLog(@"%@",error);
            }
            [self setResponse:response];
            [self setModel:model callback:^{
                [weakSelf.tableView reloadData];
                [HHHeadlineAwardHUD hideHUDAnimated:YES];
            }];
            
        }];
       
        
        
    }];
}

- (void)setModel:(HHInvitedJsonModel *)model callback:(void(^)())callback {
    
    _model = model;
    if (model.headerItem.imgUrl && model.ruleItems.count == 3) {

        [self checkCache:model.headerItem.imgUrl callback:^{
            [self checkCache:model.ruleItems[0].imgUrl callback:^{
                [self checkCache:model.ruleItems[1].imgUrl callback:^{
                    [self checkCache:model.ruleItems[2].imgUrl callback:^{
                        callback();
                    }];
                }];
            }];
        }];
    }
    
}

- (void)checkCache:(NSString *)url
          callback:(void(^)())callback{
    
    if (![[SDImageCache sharedImageCache] imageFromCacheForKey:url]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL(url) options:(SDWebImageDownloaderHighPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                callback();
        }];
    } else {
        callback();
    }
    
}

- (void)setResponse:(HHInvitedFetchSummaryResponse *)response {
    
    if (!response) {
        return;
    }
    _response = response;
    self.itemCellModels = [NSMutableArray array];
    HHMineItemCellModel *countModel = [[HHMineItemCellModel alloc] init];
    countModel.title = @"成功邀请的徒弟";
    countModel.subTitle = [NSString stringWithFormat:@"%zd人", response.userInviteInfo.count];
    
    HHMineItemCellModel *model = [[HHMineItemCellModel alloc] init];
    model.title = @"徒弟提供的总收益";
    model.subTitle = [NSString stringWithFormat:@"%@金币", [HHUtils insertComma:[NSString stringWithFormat:@"%zd",response.userInviteInfo.totalCredit]]];
    
    [self.itemCellModels addObject:countModel];
    [self.itemCellModels addObject:model];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
}

- (void)initNavigation {
    
    self.navigationView = [HHNavigationBackViewCreater customNavigationWithTarget:self action:@selector(back) text:@" 邀请收徒"];
    [self.view addSubview:self.navigationView];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.navigationView), KWIDTH, KHEIGHT - MaxY(self.navigationView)) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHMineInvitedImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineInvitedImageTableViewCell class])];
    [self.tableView registerClass:[HHMineItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineItemTableViewCell class])];
    [self.tableView registerClass:[HHMineMyInvitedCodeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineMyInvitedCodeTableViewCell class])];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.model) {
        return 4;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 1 ? self.itemCellModels.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (!self.model.headerItem) {
            return 0;
        }
        CGFloat height = [self cacheImageHeight:@[self.model.headerItem]];
        if (height) {
            return height;
        } else {
            return self.model.headerItem ? CGFLOAT(250) : 0;
        }
    } else if (indexPath.section == 1) {
        
        return self.itemCellModels[indexPath.row] ? 50 : 0;
    }  else if (indexPath.section == 2) {
        if (!self.model.ruleItems) {
            return 0;
        }
        CGFloat height = [self cacheImageHeight:self.model.ruleItems];
        if (height) {
            return height;
        } else {
            return self.model.ruleItems.count ? CGFLOAT(707) : 0;
        }
        
    }
    
    return 150;
    
}

- (CGFloat)cacheImageHeight:(NSArray<HHInvitedItem *> *)items {
    
    CGFloat height = 0;
    for (HHInvitedItem *item in items) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:item.imgUrl];
        if (image) {
            height += image.size.height / image.size.width * KWIDTH;
        }
    }
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        HHMineItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineItemTableViewCell class]) forIndexPath:indexPath];
        [cell setModel:self.itemCellModels[indexPath.row]];
        return cell;
        
    } else if (indexPath.section == 3) {
        
        HHMineMyInvitedCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineMyInvitedCodeTableViewCell class]) forIndexPath:indexPath];
        cell.invitedCode = self.response.userInviteInfo.code;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
        
        
    }   else {
        
        HHMineInvitedImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineInvitedImageTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            cell.models = self.model.headerItem ? @[self.model.headerItem] : @[];
        } else {
            cell.models = self.model.ruleItems;
        }
        
        return cell;
        
    }
    
}

#pragma mark UITableViewDelegate



#pragma mark MyInVitedCodeCellDelegate


- (void)clickCopy:(NSString *)code {
    
    if (code && ![code isEqualToString:@""]) {
        NSLog(@"%@",code);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = code;
        [HHHeadlineAwardHUD showMessage:@"内容已经复制到剪切板" animated:YES duration:2];
    }
    
}

- (void)clickQRCode:(UIImage *)image {
    if (image) {
        [self bigQRShow:image];
    }
    
}

- (void)bigQRShow:(UIImage *)image {
    
    if (!self.bigQRView) {
        self.bigQRView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.bigQRView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.50];
        self.bigQRView.userInteractionEnabled = YES;
        [self.bigQRView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBigQRView)]];
        CGFloat left = 40;
        CGFloat width = KWIDTH - left * 2;
        HHMineBigQRCodeView *bigImg = [[HHMineBigQRCodeView alloc] initWithFrame:CGRectMake(left, (KHEIGHT - width) / 2, width, 10) img:image];
        bigImg.userInteractionEnabled = YES;
        [self.view addSubview:self.bigQRView];
        [self.bigQRView addSubview:bigImg];
       
    }
    self.bigQRView.hidden = NO;
    
    
    
}

- (void)hideBigQRView {
    
    self.bigQRView.hidden = YES;
}




@end

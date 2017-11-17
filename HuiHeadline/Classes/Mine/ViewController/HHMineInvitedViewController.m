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
#import "HHMineFillInvitedCodeView.h"
#import "QRViewController.h"
#import "HHMineInvitedOneImageTableViewCell.h"
#import "HHMineInvitedCreditViewController.h"
#import "HHMineInvitedPersonViewController.h"
#import "HHActivityTaskDetailWebViewController.h"

@interface HHMineInvitedViewController () <UITableViewDataSource, UITableViewDelegate, MyInVitedCodeCellDelegate, HHMineInvitedImageTableViewCellDelegate>


@property (nonatomic, strong)UIImageView *headerItemView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HHMineItemCellModel *> *itemCellModels;

@property (nonatomic, strong)UIView *bigQRView;

@property (nonatomic, strong)UIView *fillCodeView;

@property (nonatomic, strong)HHMineFillInvitedCodeView *codeView;

@property (nonatomic, strong)UITextField *codeTF;
@end

@implementation HHMineInvitedViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (void)viewDidLoad {
    
    
    
    [self initNavigation];
    
    [self initTableView];
    
    [super viewDidLoad];
    
    [self requestData];
}

- (void)refresh {
    
    [super refresh];
    
    [self requestData];
}

- (void)requestData {
    
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [HHMineNetwork requestInviteJson:^(id error, HHInvitedJsonModel *model) {
        
        if (error) {
            NSLog(@"%@",error);
        }
        __block HHInvitedJsonModel *myModel = model;
        [HHMineNetwork requestInviteFetchSummary:^(id error, HHInvitedFetchSummaryResponse *response) {
            if (error) {
                NSLog(@"%@",error);
            }
            [self setResponse:response];
            myModel.headerItem.isInvited = response.beInvited;
            [self setModel:myModel callback:^{
                [weakSelf.tableView reloadData];
                weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
                        [self checkCache:model.bottomItems[0].imgUrl callback:^{
                            callback();
                        }];
                        
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
        
            if (image && finished) {
                ///写入缓存
                [[SDImageCache sharedImageCache] storeImage:image forKey:url completion:^{
                    callback();
                }];
            }
            
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
    self.tableView.sectionHeaderHeight = 12;
    
    [self.tableView registerClass:[HHMineInvitedImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineInvitedImageTableViewCell class])];
    [self.tableView registerClass:[HHMineItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineItemTableViewCell class])];
    [self.tableView registerClass:[HHMineMyInvitedCodeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineMyInvitedCodeTableViewCell class])];
    [self.tableView registerClass:[HHMineInvitedOneImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHMineInvitedOneImageTableViewCell class])];
    
    [self.tableView registerClass:[HHMineInvitedOneImageTableViewCell class] forCellReuseIdentifier:@"BANNER"];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.model) {
        
        return 4 + (self.model.bottomItems.count > 3);
        
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 1 ? self.itemCellModels.count : 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || (section == 3 && self.model.bottomItems.count > 3)) {
        
        return 0;
    }
    return 12;
    
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
        
        if (self.model.bottomItems.count > 3) {
            
            return [self cacheImageHeight:@[self.model.bottomItems[0]]] ? : CGFLOAT(100);
            
        } else {
            
            [self threePicHeight];
        }
        
        
    } else if (indexPath.section == 3) {
        
        if (self.model.bottomItems.count > 3) {
            
            return [self threePicHeight];
        }
    }
    return CGFLOAT(150);
    
}

- (CGFloat)threePicHeight {
    
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
    
    if (indexPath.section == 0) {
        HHMineInvitedOneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineInvitedOneImageTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model.headerItem ? self.model.headerItem : nil;
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        HHMineItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineItemTableViewCell class]) forIndexPath:indexPath];
        [cell setModel:self.itemCellModels[indexPath.row]];
        return cell;
        
    } else if (indexPath.section == 2) {
        
        if (self.model.bottomItems.count > 3) {
            
            HHMineInvitedOneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BANNER" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HHInvitedItem *item = self.model.bottomItems[0];
            item.isBanner = YES;
            cell.model = item;
            cell.delegate = self;
            return cell;
            
        } else {
            HHMineInvitedImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineInvitedImageTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.models = self.model.ruleItems;
            return cell;
        }

    }   else if (indexPath.section == 3) {
        
        if (self.model.bottomItems.count > 3) {
            HHMineInvitedImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineInvitedImageTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.models = self.model.ruleItems;
            return cell;
            
        }
        
    }
    HHMineMyInvitedCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHMineMyInvitedCodeTableViewCell class]) forIndexPath:indexPath];
    cell.invitedCode = self.response.userInviteInfo.code;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
    
}

kRemoveCellSeparator

#pragma mark UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            
            HHMineInvitedPersonViewController *vc = [HHMineInvitedPersonViewController new];
            vc.personCount = self.response.userInviteInfo.count;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            HHMineInvitedCreditViewController *vc = [HHMineInvitedCreditViewController new];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}



#pragma mark HHMineInvitedImageTableViewCellDelegate

- (void)clickBanner:(NSString *)link {
    
    HHActivityTaskDetailWebViewController *webVC = [HHActivityTaskDetailWebViewController new];
    webVC.URLString = link;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)invitedCellFillCode {
    
    if (self.codeView) {
        [self.codeView removeFromSuperview];
        self.codeView = nil;
    }
    self.fillCodeView = [HHHeadlineAwardHUD initQrcodeViewWithTarget:self action1:@selector(submit) action2:@selector(showQRCodeVC)];
    [self.view addSubview:self.fillCodeView];
    self.codeView = self.fillCodeView.subviews[0];
    
    for (UIView *subView in self.codeView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            self.codeTF = (UITextField *)subView;
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}

- (void)showQRCodeVC {
    
    QRViewController *qrvc = [QRViewController new];
    qrvc.callback = ^(NSString *error, NSString *url) {

        if (!url) {
            return ;
        }
        if (![url containsString:k_appstore_link] && ![url containsString:k_android_link]) {
            
            [HHHeadlineAwardHUD showMessage:@"该二维码格式不正确" animated:YES duration:2];
            return;
        }
        NSString *invitedCode = [[url componentsSeparatedByString:@"#code="] lastObject];
        if (invitedCode) {
            self.codeTF.text = invitedCode;
        }
        
    };
    [self presentViewController:qrvc animated:NO completion:nil];
    
}

- (void)keyBoardFrameChange:(NSNotification *)notification{
   
    NSDictionary *keyBoardDict = notification.userInfo;
//    CGRect endKeyBoardFrame = [keyBoardDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyHeight = endKeyBoardFrame.size.height;
    CGFloat duration = [keyBoardDict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    CGFloat ty = - CGFLOAT(150);
    
    [UIView animateWithDuration:duration animations:^{
        self.codeView.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)submit {
    
    if (!self.codeTF.text || [self.codeTF.text isEqualToString:@""]) {
        [HHHeadlineAwardHUD showMessage:@"请填写邀请码" animated:YES duration:2];
        
        
        return;
    }
    [HHHeadlineAwardHUD showHUDWithText:@"" animated:YES];
    [HHMineNetwork recommendWithCode:self.codeTF.text callback:^(id error, HHResponse *response) {
        [HHHeadlineAwardHUD hideHUDAnimated:YES];
        if (error) {
            [HHHeadlineAwardHUD showMessage:error animated:YES duration:2];
        } else {
            
            [self.fillCodeView removeFromSuperview];
            self.model.headerItem.isInvited = YES;
            [self.tableView reloadData];
            [HHHeadlineAwardHUD showMessage:response.msg ?: @"成功" animated:YES duration:2];
        }
    }];
    
    
}

- (void)invitedCellstNow {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"把惠头条推荐给您的家人朋友，下载并填写您的邀请码，就能躺着赚钱啦！" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
    
}



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

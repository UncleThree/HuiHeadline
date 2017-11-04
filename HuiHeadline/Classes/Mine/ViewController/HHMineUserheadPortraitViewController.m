//
//  HHMineUserHeaderViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/19.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineUserheadPortraitViewController.h"

@interface HHMineUserheadPortraitViewController ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation HHMineUserheadPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initImageView];
   
    
}



- (void)initImageView {
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.imageView sd_setImageWithURL:URL(_url) placeholderImage:[UIImage imageNamed:@"user_default_icon"]];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12);
        make.right.equalTo(self.view).with.offset(-12);
        make.width.height.mas_equalTo(KWIDTH - 24);
        make.center.equalTo(self.view);
    }];
}

- (void)initNavigation {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[HHNavigationBackViewCreater customBarItemWithTarget:self action:@selector(back) text:@" 个人头像"]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIImage *image = [UIImage imageNamed:@"menu_icon_more"];
    CGFloat height = 20.0f;
    CGFloat width = image.size.width / image.size.height * height;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[image scaleToSize:CGSizeMake(width, height)] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectPicture)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectPicture {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    [self.navigationController presentViewController:alert animated:YES completion:^{
        
    }];
    
    
    
}



@end

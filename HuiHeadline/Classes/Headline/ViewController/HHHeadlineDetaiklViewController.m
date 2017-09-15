//
//  HHHeadlineDetaiklViewController.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/13.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineDetaiklViewController.h"

@interface HHHeadlineDetaiklViewController ()

@end

@implementation HHHeadlineDetaiklViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"%@ load",self.type);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@ appear",self.type);
}


@end

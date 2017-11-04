//
//  HHTopNewsModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/20.
//  Copyright © 2017年 eyuxin. All rights reserved.
//
/*
 private Long id;
 
 private String title;
 
 private String source;
 
 private short style;
 
 private String pictures;
 
 private String url;
 
 private Date mediaCreateTime;
 */
#import <Foundation/Foundation.h>
#import "HHBaseModel.h"

@interface HHTopNewsModel : HHBaseModel

@property (nonatomic)long topNews_id;

@property (nonatomic)long mediaCreateTime;

@property (nonatomic, copy)NSString *subTitle;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *source;

@property (nonatomic)int style;

@property (nonatomic, copy)NSString *pictures;

@property (nonatomic, copy)NSString *url;



@property (nonatomic, copy)NSString *timeString;

///pictures根据分号分割的数组
@property (nonatomic, strong)NSArray<NSString *> *pictureUrls;


@end

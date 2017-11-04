//
//  HHHeadlineNewsModel.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHBaseModel.h"



@interface HHNewsModel : HHBaseModel

///是否是大图cell
@property (nonatomic, assign)BOOL bigpic;
//.评论数
@property (nonatomic, assign)NSInteger commentcnt;
///时间
@property (nonatomic, assign)NSTimeInterval date;
///是否是hot news
@property (nonatomic, assign)BOOL hotnews;
///https url
@property (nonatomic, copy)NSString *httpsurl;
///是否是推荐
@property (nonatomic, assign)BOOL isrecom;
///是否是video
@property (nonatomic, assign)BOOL isvideo;
///
@property (nonatomic, copy)NSArray<NSDictionary *> *lbimg;
///小图.
@property (nonatomic, copy)NSArray<NSDictionary *> *miniimg;
///小图个数
@property (nonatomic, assign)NSInteger miniimg_size;
///推荐类型
@property (nonatomic, copy)NSString *recommendtype;
///推荐Url
@property (nonatomic, copy)NSString *recommendurl;
///row key
@property (nonatomic, copy)NSString *rowkey;
///来源
@property (nonatomic, copy)NSString *source;
///subtype
@property (nonatomic, copy)NSString *subtype;

///类型
@property (nonatomic, copy)NSString *type;
///url
@property (nonatomic, copy)NSString *url;
///dongfang / tencent
@property (nonatomic, copy)NSString *urlfrom;
///videoalltime
@property (nonatomic, assign)BOOL videoalltime;

///时间字符串
@property (nonatomic, copy)NSString *timeString;
//广告后面的图片 + 100/200金币 nil代表没有
@property (nonatomic, copy)NSString *award;
//是否置顶
@property (nonatomic)BOOL isStick;

@property (nonatomic, copy)NSString *subTitle;

@property (nonatomic, copy)NSString *title;






@end

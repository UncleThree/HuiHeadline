//
//  HHConst.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#ifndef HHConst_h
#define HHConst_h

//应用程序的屏幕高度
#define KWIDTH         UIScreen.mainScreen.bounds.size.width
//应用程序的屏幕宽度
#define KHEIGHT        UIScreen.mainScreen.bounds.size.height

#define STATUSBAR_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height

#define PROGRESS_KWIDTH CGFLOAT(120)

#define VIDEO_AD_HEIGHT 130.0

#define UUID [UIDevice currentDevice].identifierForVendor.UUIDString

#define APP_VER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//CFBundleShortVersionString version
#define APP_VER_SHORT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define segmentHeight 44.0

//自定义Log 方便查找
#define Log(arg) NSLog(@" %s : %dL %@", __func__, __LINE__, arg)
//标题字体

#define kTitleFont      Font(18)

//子标题字体
#define kSubtitleFont      Font(15)

#define LARGE KWIDTH >= 414
#define NORMAL KWIDTH >= 375

//不做适应的font
#define K_Font(size) [UIFont systemFontOfSize:size]
//中屏幕降低一个fontSize 小屏幕降低两个fontSize 320 375 414 
#define Font(size)         LARGE ? [UIFont systemFontOfSize:size] : (NORMAL ? [UIFont systemFontOfSize:size - 1] : [UIFont systemFontOfSize:size - 2])

//适配屏幕的CGFloat 按照plus的比例适配高度
#define CGFLOAT(float)  ((CGFloat)(float * (KHEIGHT / 736.0)))

#define CGFLOAT_W(float) ((CGFloat)(float * (KWIDTH / 414.0)))

//通过RGB设置颜色
#define RGB(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

#define BLACK_51 RGB(51,51,51)
#define BLACK_153 RGB(153,153,153)
#define HUIRED RGB(229,54,39)
///0.28的黑色背景色
#define TRAN_BLACK [UIColor colorWithWhite:0 alpha:0.28]

#define GRAYCELL [UIColor colorWithWhite:0.95 alpha:1]

#define HUIYELLOW RGB(254,234,119)

//attributes 字典系统的KEY

#define KEY_FONT NSFontAttributeName
#define KEY_COLOR NSForegroundColorAttributeName 


//设置Button文字 字体 颜色

#define kButton_setAttr_normalState(button,title,color,font) [button setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];

#define MinX(view) CGRectGetMinX(view.frame)
#define MaxX(view) CGRectGetMaxX(view.frame)
#define MinY(view) CGRectGetMinY(view.frame)
#define MaxY(view) CGRectGetMaxY(view.frame)
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define W(view) view.frame.size.width
#define H(view) view.frame.size.height

//URL utf8编码

#define URL(str) [NSURL URLWithString: [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]


//移除iOS7之后，cell默认左侧的分割线边距   Preserve:保存
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
    cell.separatorInset = UIEdgeInsetsZero;\
    cell.layoutMargins = UIEdgeInsetsZero; \
    cell.preservesSuperviewLayoutMargins = NO; \
}

//加密KEY
#define AESKEY @"d2=r?bc-l55hH.87"

//回调
typedef void(^Block)(NSError *error,id result);

#define WX_APPID @"wx95837f9bce09e2be"

//#define WX_APPID @"wxd0be1cf0ca04364b"

#endif /* HHConst_h */

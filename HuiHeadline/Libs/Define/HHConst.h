//
//  HHConst.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/12.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#ifndef HHConst_h
#define HHConst_h

//自定义Log 方便查找
#define Log(arg) NSLog(@"%s:%dL %@", __func__, __LINE__, arg)
//标题字体
#define kTitleFont      [UIFont systemFontOfSize:15]
//子标题字体
#define kSubtitleFont      [UIFont systemFontOfSize:13]

#define Font(size)          [UIFont systemFontOfSize:size]

//通过RGB设置颜色
#define RGB(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//应用程序的屏幕高度
#define KWIDTH         UIScreen.mainScreen.bounds.size.width
//应用程序的屏幕宽度
#define KHEIGHT        UIScreen.mainScreen.bounds.size.height

#define MinX(view) CGRectGetMinX(view.frame)
#define MaxX(view) CGRectGetMaxX(view.frame)
#define MinY(view) CGRectGetMinY(view.frame)
#define MaxY(view) CGRectGetMaxY(view.frame)
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define W(view) view.frame.size.width
#define H(view) view.frame.size.height


//移除iOS7之后，cell默认左侧的分割线边距   Preserve:保存
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}


//

#define AESKEY @"d2=r?bc-l55hH.87"




#endif /* HHConst_h */

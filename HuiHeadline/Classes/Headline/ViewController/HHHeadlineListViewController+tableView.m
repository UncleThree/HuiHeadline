//
//  HHHeadlineListViewController+tableView.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/18.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineListViewController+tableView.h"
#import "HHNewsModel.h"
#import "HHHeadlineNewsThreePicTableViewCell.h"
#import "HHHeadlineNewsLeftRightTableViewCell.h"
#import "HHHeadlineNewsBigImgTableViewCell.h"
#import "HHHeadlineNewsBaseTableViewCell.h"
#import "HHHeadlineListWebViewController.h"
#import "HHBaseModel.h"
#import "HHHeadlineListAdWebViewController.h"

@implementation HHHeadlineListViewController (tableView)


#pragma mark dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.topData.count;
    }
    NSInteger count = self.newsData.count;
    
    return count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHHeadlineNewsBaseTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        HHTopNewsModel *model = self.topData[indexPath.row];
        
        NSArray *identyfiers = @[leftRightCell,normalCell,bigImgCell];
        cell = [tableView dequeueReusableCellWithIdentifier:identyfiers[model.type_cell] forIndexPath:indexPath];
        [cell setModel:model];
        
        return cell;
        
    } else  if ( (indexPath.row - 1) % 6 == 0 ) {
        
        HHAdModel *model = nil;
        if (self.adData.count && self.adData.count - 1 >= (indexPath.row - 1) / 6) {
            model = self.adData[ (indexPath.row - 1) / 6 ];
            
            ///曝光显示出来的cell
            if ([[tableView indexPathsForVisibleRows] containsObject:indexPath] && !model.exporsed) {
                model.exporsed = YES;
                [self handlerAdExposure:model];
            }
        } else {
            ///mark
            return [UITableViewCell new];
        }
        NSArray *identyfiers = @[leftRightCell,normalCell,bigImgCell];
        cell = [tableView dequeueReusableCellWithIdentifier:identyfiers[model.type_cell] forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    } else {
        
        HHNewsModel *model = self.newsData[indexPath.row];
        NSArray *identyfiers = @[leftRightCell,normalCell,bigImgCell];
        cell = [tableView dequeueReusableCellWithIdentifier:identyfiers[model.type_cell] forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBaseModel *model = nil;
    if (indexPath.section == 0) {
        
        model = self.topData[indexPath.row];
        
    }
    else if ((indexPath.row - 1) % 6 == 0) {
        
        if (self.adData.count && self.adData.count - 1 >= (indexPath.row - 1) / 6 ) {
            
            model = self.adData[ (indexPath.row - 1) / 6 ];
            
        }
        
    }
    else {
        
        model = self.newsData[indexPath.row];
    }
    if (!model) {
        
        return 0;
    }
    return [model heightForCell];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}





#pragma mark dataSource



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HHBaseModel *model = nil;
    if (indexPath.section == 0) {
        model = self.topData[indexPath.row];
    } else if ( (indexPath.row - 1) % 6 == 0) {
        model = self.adData[ (indexPath.row - 1) / 6 ];
    } else {
        model = self.newsData[indexPath.row];
    }
    model.hasClicked = YES;
    //点击新闻
    HHHeadlineListWebViewController *webVC = [[HHHeadlineListWebViewController alloc] init];
    if ([model isKindOfClass:[HHNewsModel class]]) {
        webVC.URLString = [(HHNewsModel *)model httpsurl];
    } else if ([model isKindOfClass:[HHAdModel class]]) {
         webVC.URLString = [(HHAdModel *)model landingUrl];
        
    
        
    } else {
        webVC.URLString = [(HHTopNewsModel *)model url];
    }
    webVC.clickCallback = ^{
        //刷新点击的cell 通过model的hasClicked设置点击样式
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
    };
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    webVC.hidesBottomBarWhenPushed = NO;
    [self showNav:NO];
    
    
}




@end

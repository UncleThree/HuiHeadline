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
#import "HHAdAwardManager.h"

@implementation HHHeadlineListViewController (tableView)


#pragma mark dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.topData.count;
    }
    NSInteger count = self.data.count;
    
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
            model = self.adData[(indexPath.row - 1) / 6];
            
            ListAdEncourageInfo *info = [[HHAdAwardManager sharedInstance] getEncourageInfoMap:model.type];
            if (info && info.credit) {
                model.AdAwards = [NSString stringWithFormat:@"+%zd金币", info.credit];
            } else {
                model.AdAwards = nil;
            }
            ///曝光显示出来的cell
            if ([[tableView indexPathsForVisibleRows] containsObject:indexPath] && !model.exporsed ) {
                
                ///图片加载出来的广告曝光 否则不曝光
                [self makesureAd:model callback:^(BOOL isInCache) {
                    
                    if (isInCache) {
                    
                        model.exporsed = YES;
                        [self handlerAdExposure:model];
                    }
                    
                }];
                
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
        
        HHNewsModel *model = (HHNewsModel *)self.data[indexPath.row];
        NSArray *identyfiers = @[leftRightCell,normalCell,bigImgCell];
        cell = [tableView dequeueReusableCellWithIdentifier:identyfiers[model.type_cell] forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    
    
}

///判断广告图片是否加载出来
- (void)makesureAd:(HHAdModel *)ad
          callback:(void(^)(BOOL isInCache))callback{

    if (ad && ad.imgList.count) {
        
        NSURL *url  = URL(ad.imgList[0]);
        [[SDWebImageManager sharedManager] diskImageExistsForURL:url completion:^(BOOL isInCache) {
            callback(isInCache);
        }];
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
            
        } else {
            return 0;
        }
        
    }
    else {
        
        model = self.data[indexPath.row];
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
        model = self.data[indexPath.row];
    }
    model.hasClicked = YES;
    //点击新闻
    HHHeadlineListWebViewController *webVC = [[HHHeadlineListWebViewController alloc] init];
    if ([model isKindOfClass:[HHNewsModel class]]) {
        
        webVC.URLString = [(HHNewsModel *)model httpsurl];
        webVC.shareTitle = [(HHNewsModel *)model title];
        
    } else if ([model isKindOfClass:[HHAdModel class]]) {
        
         webVC.URLString = [(HHAdModel *)model landingUrl];
         webVC.shareTitle = [(HHAdModel *)model title];
    
        [self adAward:(HHAdModel *)model];
        
    } else {
        webVC.URLString = [(HHTopNewsModel *)model url];
        webVC.shareTitle = [(HHTopNewsModel *)model title];
    }
    
    webVC.clickCallback = ^{
        //刷新点击的cell 通过model的hasClicked设置点击样式

        [tableView reloadData];
    };
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    webVC.hidesBottomBarWhenPushed = NO;
    [self showNav:NO];
    
    
}

- (void)adAward:(HHAdModel *)ad {
    
    if (!ad.clicked) {
        
        [HHHeadlineNetwork sychClickList:ad.clickReportList];
        ad.clicked = YES;
        
    }
    
    if (ad.AdAwards) {
        
        ListAdEncourageInfo *info = [[HHAdAwardManager sharedInstance] getEncourageInfoMap:ad.type];
        if (info && info.token) {
            
            [HHHeadlineNetwork sychAdClickAwardWithToken:info.token channel:ad.type callback:^(id error, HHSychAdAwardResponse *response) {
                
                
                if (response.statusCode == 200) {
                    
                    [[HHAdAwardManager sharedInstance] disposeEncourageInfoMap:@{ad.type:@{}}];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
                
            }];
        }
        
    }
    
}




@end

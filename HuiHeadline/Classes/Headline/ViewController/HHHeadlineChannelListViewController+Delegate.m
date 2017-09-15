//
//  HHHeadlineChannelListViewController+Delegate.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/15.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHHeadlineChannelListViewController+Delegate.h"
#import "BMTodayHeadlinesDragCell.h"
#import "HHHeadlineChannelListHeaderView.h"
#import "HHHeadlineChannelListSecondHeaderView.h"

@implementation HHHeadlineChannelListViewController (Delegate)


// dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSourceArray.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BMTodayHeadlinesDragCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *title = self.dataSourceArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        
        cell.removeButton.hidden = !self.showDeleteButton;
        cell.titleLabel.text = title;
        cell.titleLabel.textColor = indexPath.row ? UIColor.blackColor : UIColor.redColor;
        
    } else {
        cell.removeButton.hidden = YES;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"＋%@", title];
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *cell = nil;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        [[(HHHeadlineChannelListHeaderView *)cell editButton] addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSecoundHeaderIdentifier forIndexPath:indexPath];
    }
    return cell;
    
}

- (void)editClick:(UIButton *)button {
    
    [button setTitle:self.showDeleteButton ? @"编辑" : @"完成" forState:UIControlStateNormal];
    self.showDeleteButton = !self.showDeleteButton;
    [self.dragCollectionView reloadData];
    
}



// delegate

- (NSArray *)dataSourceWithDragCellCollectionView:(BMDragCellCollectionView *)dragCellCollectionView {
    
    return self.dataSourceArray;
}

- (void)dragCellCollectionView:(BMDragCellCollectionView *)dragCellCollectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    self.dataSourceArray = [newDataArray mutableCopy];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.item == 0) {
//        return ;
//    }
    
    if (indexPath.section == 0) {
        // 删除操作
        NSString *title = self.dataSourceArray[indexPath.section][indexPath.row];
        
        BMTodayHeadlinesDragCell *cell = (BMTodayHeadlinesDragCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.removeButton.hidden = YES;
        cell.titleLabel.text = [NSString stringWithFormat:@"＋ %@", title];
        NSMutableArray *secArray0 = self.dataSourceArray[indexPath.section];
        [secArray0 removeObject:title];
        
        NSMutableArray *secArray1 = self.dataSourceArray[1];
        [secArray1 addObject:title];
        
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:secArray1.count-1 inSection:1]];
    } else {
        // 添加操作
        NSString *title = self.dataSourceArray[indexPath.section][indexPath.row];
        
        BMTodayHeadlinesDragCell *cell = (BMTodayHeadlinesDragCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
        cell.titleLabel.text = title;
        
        NSMutableArray *secArray1 = self.dataSourceArray[1];
        [secArray1 removeObject:title];
        
        NSMutableArray *secArray0 = self.dataSourceArray[0];
        [secArray0 addObject:title];
        
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:secArray0.count-1 inSection:0]];
        
        
    }
}

- (BOOL)dragCellCollectionViewShouldBeginExchange:(BMDragCellCollectionView *)dragCellCollectionView sourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.section == 1 || sourceIndexPath.section == 1) {
        return NO;
    }
    if (destinationIndexPath.section == 0 && destinationIndexPath.item == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)dragCellCollectionViewShouldBeginMove:(BMDragCellCollectionView *)dragCellCollectionView indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    if (indexPath.section == 0 && indexPath.item == 0) {
        return NO;
    }
    return YES;
}



- (BOOL)dragCellCollectionView:(BMDragCellCollectionView *)dragCellCollectionView endedDragAutomaticOperationAtPoint:(CGPoint)point section:(NSInteger)section indexPath:(NSIndexPath *)indexPath {
    if (section == 1) {
        // 如果拖到了第一组松开就移动 而且内部不自动处理
        [dragCellCollectionView dragMoveItemToIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        return NO;
    }
    return YES;
}




@end

//
//  WWWallpaperCollectionView.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//
// 壁纸列表瀑布流布局视图

#import <UIKit/UIKit.h>
#import "WWWallpaperItemModel.h"

@interface WWWallpaperCollectionView : UICollectionView

@property (nonatomic, copy) void (^loadData)(NSInteger pageIndex, void(^load)(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data));
@property (nonatomic, copy) void (^cellDidTap)(WWWallpaperItemModel *model, NSIndexPath *indexPath);

- (void)loadData:(NSMutableArray<WWWallpaperItemModel *> *)data pageIndex:(NSInteger)pageIndex;
- (void)setupRefreshHeader;
- (void)setupLoadFooter;

@end


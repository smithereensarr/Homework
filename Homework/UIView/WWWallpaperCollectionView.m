//
//  WWWallpaperCollectionView.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperCollectionView.h"
#import <UIScrollView+MJRefresh.h>
#import <MJRefreshNormalHeader.h>
#import <MJRefreshAutoNormalFooter.h>
#import "WWVerticalFlowLayout.h"
#import "WWWallpaperCell.h"

static NSString * const kWallpaperCellIdentifier = @"kWallpaperCellIdentifier";

@interface WWWallpaperCollectionView () <WWVerticalFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray<WWWallpaperItemModel *> *data;
@property (nonatomic ,assign) NSInteger pageIndex;
@end

@implementation WWWallpaperCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    WWVerticalFlowLayout *flowLayout = [[WWVerticalFlowLayout alloc] initWidthDelegate:self];
    
    self = [self initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)loadData:(NSMutableArray<WWWallpaperItemModel *> *)data pageIndex:(NSInteger)pageIndex
{
    if (pageIndex == 0) {
        [self.data removeAllObjects];
    }
    [self.data addObjectsFromArray:data];
    
    [self reloadData];
}

- (void)setupRefreshHeader
{
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    refreshHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.mj_header = refreshHeader;
}

- (void)setupLoadFooter
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.mj_footer = footer;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WWWallpaperItemModel *itemModel = self.data[indexPath.row];
    
    WWWallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWallpaperCellIdentifier forIndexPath:indexPath];
    [cell loadData:itemModel];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WWWallpaperItemModel *itemModel = self.data[indexPath.row];
    if (self.cellDidTap) {
        self.cellDidTap(itemModel, indexPath);
    }
}

#pragma mark - WWVerticalFlowLayoutDelegate
- (CGFloat)cellWHRateForIndexPath:(NSIndexPath *)indexPath
{
    WWWallpaperItemModel *model = self.data[indexPath.row];
    if (model.height == 0) {
        return 0;
    }
    
    return model.width / model.height;
}

#pragma mark - private
- (void)setup
{
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[WWWallpaperCell class] forCellWithReuseIdentifier:kWallpaperCellIdentifier];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)beginRefresh
{
    //没有实现加载方法则跳出
    if (!self.loadData) {
        [self.mj_header endRefreshing];
        return;
    }
    
    self.loadData(0, ^(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data) {
        [self.mj_header endRefreshing];
        if (!errorMsg) {
            self.pageIndex = 0;
            [self loadData:data pageIndex:self.pageIndex];
        }
    });
}
                                
- (void)loadMore
{
    //没有实现加载方法则跳出
    if (!self.loadData) {
        [self.mj_footer endRefreshing];
        return;
    }
    
    self.loadData(self.pageIndex + 1, ^(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data) {
        [self.mj_footer endRefreshing];
        if (!errorMsg) {
            self.pageIndex++;
            [self loadData:data pageIndex:self.pageIndex];
        }
    });
}

#pragma mark - property
- (NSMutableArray<WWWallpaperItemModel *> *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}
@end

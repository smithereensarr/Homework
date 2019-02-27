//
//  WWWallpaperListController.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperListController.h"
#import <YYImageCache.h>
#import <Masonry.h>
#import <JGProgressHUD.h>
#import "WWWallpaperDataService.h"
#import "WWWallpaperItemModel.h"
#import "WWWallpaperCollectionView.h"
#import "UIView+WWHud.h"
#import "WWWallpaperDetailController.h"
#import "WWEntrancePhysicsAnimation.h"

@interface WWWallpaperListController () 
@property (nonatomic, assign) BOOL isDataInitialized;
@property (nonatomic, strong) WWWallpaperCollectionView *collectionView;
@property (nonatomic, strong) WWEntrancePhysicsAnimation *entranceAnimation;
@end

@implementation WWWallpaperListController

#pragma mark - lifeCycle

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
//    [animator removeAllBehaviors];
//    animator = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isDataInitialized) {
        //初始化入场动画
        self.entranceAnimation = [[WWEntrancePhysicsAnimation alloc] initWith:self.view completion:nil];
        [self.entranceAnimation readyAnimation];
        //首次进入加载数据
        self.collectionView.loadData(0, ^(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data) {
            [self.collectionView loadData:data pageIndex:0];
            //根据首次加载情况初始化刷新控件
            [self.collectionView setupRefreshHeader];
            if (data.count > 0) {
                [self.collectionView setupLoadFooter];
            }
            //加载完成，执行入场动画（这里的执行顺序只是为了表现视觉效果）
            [self.entranceAnimation startAnimation];
        });

        self.isDataInitialized = YES;
    }
}

#pragma mark - private
- (void)setup
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)){
        //兼容iOS11以后的异形屏
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }];
    } else {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

- (void)gotoPhotoDetailPage:(WWWallpaperItemModel *)model indexPatch:(NSIndexPath *)indexPatch
{
    UIView *viewDidTaped = [self.collectionView cellForItemAtIndexPath:indexPatch];
    CGRect frame = [self.view convertRect:viewDidTaped.frame fromView:viewDidTaped.superview];
    UIImage *thumbImg = [[YYImageCache sharedCache] getImageForKey:model.smallUrl.absoluteString];
    
    WWWallpaperDetailController *detailVC = [[WWWallpaperDetailController alloc] initWithOriginFrame:frame];
    self.transitioningDelegate = detailVC;
    detailVC.transitioningDelegate = detailVC;
    [self presentViewController:detailVC animated:YES completion:nil];
    [detailVC loadPhoto:thumbImg photoId:model.itemId];
}

- (void)getWallpaperList:(NSInteger)pageIndex load:(void(^)(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data))load
{
    [WWWallpaperDataService getWallpaperList:pageIndex prePate:10 orderBy:WWWallPaperOrderByLatest completion:^(id data, NSString *errorMsg) {
        if (load) {
            load(errorMsg, data);
        }
        if (errorMsg) {
            [self.view ww_showErrorMsg:errorMsg];
        }
    }];
}

#pragma mark - property
- (WWWallpaperCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[WWWallpaperCollectionView alloc] init];
        __weak WWWallpaperListController *weakSelf = self;
        //加载数据回调
        [_collectionView setLoadData:^(NSInteger pageIndex, void (^load)(NSString *errorMsg, NSMutableArray<WWWallpaperItemModel *> *data)) {
            __strong WWWallpaperListController *strongSelf = weakSelf;
            [strongSelf getWallpaperList:pageIndex load:load];
        }];
        //点击壁纸跳转到大图页
        [_collectionView setCellDidTap:^(WWWallpaperItemModel *model, NSIndexPath *indexPath) {
            __strong WWWallpaperListController *strongSelf = weakSelf;
            [strongSelf gotoPhotoDetailPage:model indexPatch:indexPath];
        }];
    }
    return _collectionView;
}
@end

//
//  WWWallpaperDetailController.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperDetailController.h"
#import <UIImageView+YYWebImage.h>
#import <Masonry.h>
#import <JGProgressHUD.h>
#import <Photos/Photos.h>
#import "WWWallpaperDataService.h"
#import "UIView+WWHud.h"

@interface WWWallpaperDetailController () <UIViewControllerAnimatedTransitioning, UIScrollViewDelegate>
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) NSURLSessionDataTask *currentPhotoUrlTask;
@end

@implementation WWWallpaperDetailController

- (instancetype)initWithOriginFrame:(CGRect)originFrame
{
    self = [self init];
    if (self) {
        self.originFrame = originFrame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.hud.alpha = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.hud.alpha = 0.0;
    [self.hud dismiss];
    self.hud = nil;
    //还原缩放
    [self.scrollView setZoomScale:1.0];
    //取消正在进行的请求
    [self.currentPhotoUrlTask cancel];
    [self.imgView yy_cancelCurrentImageRequest];
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"ww_photoPage dealloc");
#endif
}

- (void)loadPhoto:(UIImage *)placeholder photoId:(NSString *)photoId
{
    //先显示小图
    self.imgView.image = placeholder;
    
    if (!photoId) {
        return;
    }
    
    //显示记加载指示器
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.hud.userInteractionEnabled = NO;
    self.hud.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
    self.hud.progress = 0.0;
    [self.hud showInView:self.view];
    self.hud.alpha = 0.0;
    CGFloat httpProgress = 0.05;
    //查找大图地址
    self.currentPhotoUrlTask = [WWWallpaperDataService getPhoto:photoId completion:^(id data, NSString *errorMsg) {
        if (data) {
            //网络请求占比固定值
            [self.hud setProgress:httpProgress animated:YES];
            WWPhotoModel *model = data;
            //下载或取出缓存大图
            [[YYWebImageManager sharedManager] requestImageWithURL:model.rawUrl options:(YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //显示加载进度
                if (expectedSize) {
                    self.hud.progress = ((float)receivedSize / expectedSize + httpProgress) / (1 + httpProgress);
                }
            } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud setProgress:1.0 animated:YES];
                    [self.hud dismiss];
                    if (image) {
                        self.photo = image;
                        self.saveBtn.enabled = YES;
                        [self.scrollView setZoomScale:1.0];
                        self.imgView.image = image;
                    } else if (error) {
                        [self.view ww_showErrorMsg:error.localizedDescription];
                    }
                });
            }];
        } else {
            [self.hud dismiss];
            if (![errorMsg isEqualToString:@"cancelled"]) {
                //大图地址请求失败
                [self.view ww_showErrorMsg:errorMsg];
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.18f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromVc.transitioningDelegate = self;
    toVc.transitioningDelegate = self;
    
    if (toVc == self) {
        //入场
        toVc.view.frame = self.originFrame;
        [toVc.view layoutIfNeeded];
        [[transitionContext containerView] addSubview:toVc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            toVc.view.frame = [UIScreen mainScreen].bounds;
            [toVc.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        //出场
        [[transitionContext containerView] insertSubview:toVc.view belowSubview:fromVc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            fromVc.view.frame = self.originFrame;
            [fromVc.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

#pragma mark - private
- (void)setup
{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imgView];
    self.saveBtn.enabled = NO;
    [self.view addSubview:self.saveBtn];
    //
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.mas_equalTo(-20);
        }
    }];
    
    //点击退出
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(dismissViewControllerAnimatedWithAniamte)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dismissViewControllerAnimatedWithAniamte
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePhoto
{
    if (!self.photo) {
        return;
    }
    
    //获取相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:self.photo];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view ww_showSuccessMsg:@"保存成功"];
                    //不允许重复保存
                    self.saveBtn.enabled = NO;
                    [self.saveBtn setTitle:@"saved" forState:UIControlStateNormal];
                });
            }];
        } else if (status == PHAuthorizationStatusDenied) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view ww_showErrorMsg:@"请开启APP相册权限"];
            });
        }
    }];
}

#pragma mark - property
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
    }
    return _scrollView;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"Save Photo" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_saveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
@end

//
//  WWWallpaperDetailController.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//
// 壁纸详情（大图）页

#import <UIKit/UIKit.h>


@interface WWWallpaperDetailController : UIViewController <UIViewControllerTransitioningDelegate>

- (instancetype)initWithOriginFrame:(CGRect)originFrame;
- (void)loadPhoto:(UIImage *)placeholder photoId:(NSString *)photoId;

@end


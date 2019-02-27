//
//  WWWallpaperItemModel.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import <CoreGraphics/CGBase.h>

@interface WWWallpaperItemModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSURL *regularUrl;
@property (nonatomic, strong) NSURL *smallUrl;

@end


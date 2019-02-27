//
//  WWWallpaperItemModel.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperItemModel.h"

@implementation WWWallpaperItemModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"itemId" : @"id",
             @"regularUrl" : @"urls.regular",
             @"smallUrl" : @"urls.small"
             };
}

@end

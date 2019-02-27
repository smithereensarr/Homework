//
//  WWWallpaperDataService.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWWallpaperDataService.h"

@implementation WWWallpaperDataService

+ (NSURLSessionDataTask *)getWallpaperList:(NSInteger)pageIndex prePate:(NSInteger)prePate orderBy:(WWWallPaperOrderBy)orderBy completion:(responseBlock)completion
{
    NSString *orderByStr = nil;
    switch (orderBy) {
        case WWWallPaperOrderByLatest:
            orderByStr = @"latest";
            break;
        case WWWallPaperOrderByOldest:
            orderByStr = @"oldest";
            break;
        case WWWallPaperOrderByPopular:
            orderByStr = @"popular";
            break;
        default:
            orderByStr = @"latest";
            break;
    }
    
    //本API页数序号从1开始
    return [WWRequest getRequest:@"photos" params:@{@"page":@(pageIndex + 1), @"per_page":@(prePate), @"order_by":orderByStr} returnClass:[WWWallpaperItemModel class] completion:completion];
}

+ (NSURLSessionDataTask *)getPhoto:(NSString *)photoId completion:(responseBlock)completion
{
    if (!photoId) {
        if (completion) {
            completion(nil, @"缺少必要参数");
        }
    }
    
    return [WWRequest getRequest:[NSString stringWithFormat:@"photos/%@", photoId] params:nil returnClass:[WWPhotoModel class] completion:completion];
}
@end

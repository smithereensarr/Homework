//
//  WWWallpaperDataService.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WWRequest.h"
#import "WWWallpaperItemModel.h"
#import "WWPhotoModel.h"

typedef NS_ENUM(NSUInteger, WWWallPaperOrderBy) {
    WWWallPaperOrderByLatest = 0,
    WWWallPaperOrderByOldest,
    WWWallPaperOrderByPopular,
};

@interface WWWallpaperDataService : NSObject

+ (NSURLSessionDataTask *)getWallpaperList:(NSInteger)pageIndex prePate:(NSInteger)prePate orderBy:(WWWallPaperOrderBy)orderBy completion:(responseBlock)completion;
+ (NSURLSessionDataTask *)getPhoto:(NSString *)photoId completion:(responseBlock)completion;

@end


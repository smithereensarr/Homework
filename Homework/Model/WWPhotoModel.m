//
//  WWPhotoModel.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//

#import "WWPhotoModel.h"

@implementation WWPhotoModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"photoId" : @"id",
             @"rawUrl" : @"urls.full"//这里由于后端或节点网速原因取full
             };
}

@end

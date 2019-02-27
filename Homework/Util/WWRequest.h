//
//  WWRequest.h
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//
// 快速创建http请求简易封装

#import <Foundation/Foundation.h>

typedef void(^responseBlock)(id data, NSString *errorMsg);

@interface WWRequest : NSObject


/**
 简易get请求封装（强制缓存）

 @param UrlStr url字符串
 @param params get参数
 @param returnClass 返回数据解析模型类（NSArray泛型直接使用泛型约束类）
 @param completion 响应回调
 @return task
 */
+ (NSURLSessionDataTask *)getRequest:(NSString *)UrlStr params:(NSDictionary *)params returnClass:(Class)returnClass completion:(responseBlock)completion;

@end


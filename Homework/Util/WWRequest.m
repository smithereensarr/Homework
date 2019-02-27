//
//  WWRequest.m
//  Homework
//
//  Created by 王威 on 2019/2/26.
//  Copyright © 2019 王威. All rights reserved.
//


#import "WWRequest.h"
#import <AFNetworking.h>
#import <YYModel.h>

static NSString * const kDomain = @"https://api.unsplash.com/";
static NSString * const kToken = @"e3166b3ff2fceb9a5327f66717345a49c01c221994a812749d0b42d2a594bc68";

@implementation WWRequest

#pragma mark - public
+ (NSURLSessionDataTask *)getRequest:(NSString *)UrlStr params:(NSDictionary *)params returnClass:(Class)returnClass completion:(responseBlock)completion
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [self getRequestFor:UrlStr params:params];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
#ifdef DEBUG
            NSLog(@"ww_httpResponse:%@", responseObject);
#endif
            //强制储存缓存（这里不考虑与服务端的Last-Modified、Etag、Expires、Cache-Control等等缓存协议细节，仅简易实现）
            [self cacheResponse:response forRequest:request jsonData:responseObject];
            //解析回调数据
            NSString *errorMsg = [[NSString alloc] init];
            id data = [self dataParse:responseObject parseClass:returnClass error:&errorMsg];
            if (completion) {
                completion(data, errorMsg);
            }
        } else {
            //请求错误
            if (completion) {
                completion(nil, error.localizedDescription);
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

#pragma mark - private
+ (NSURLRequest *)getRequestFor:(NSString *)relativeUrlStr params:(NSDictionary *)params
{
    if (relativeUrlStr.length == 0) {
        return nil;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"get";
    //HTTPHeader
    [request addValue:[NSString stringWithFormat:@"Client-ID %@", kToken] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"v1" forHTTPHeaderField:@"Accept-Version"];
    //拼接get请求串
    NSMutableString *fullUrl = [[NSMutableString alloc] initWithString:kDomain];
    [fullUrl appendString:relativeUrlStr];
    if (params.count > 0) {
        [fullUrl appendString:@"?"];
        for (NSString *key in params) {
            [fullUrl appendString:[NSString stringWithFormat:@"&%@=%@", key, params[key]]];
        }
    }
    request.URL = [NSURL URLWithString:fullUrl];
    //在无网络情况下强制读取离线缓存
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        //在网络状态还未获取到的情况下优先加载缓存
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    } else {
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            request.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        }
    }
    
    return request;
}

+ (void)cacheResponse:(NSURLResponse *)response forRequest:(NSURLRequest *)request jsonData:(id)jsonData
{
    //这里不校验缓存时效性，简易实现
    NSData *dataFromJson = [NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
    if (dataFromJson) {
        NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:dataFromJson];
        [[NSURLCache sharedURLCache] storeCachedResponse:cacheResponse forRequest:request];
    }
}

+ (id)dataParse:(id)responseObject parseClass:(Class)parseClass error:(NSString **)error
{
    if (parseClass) {
        //需要模型映射解析
        id parseData = nil;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            //返回数据是一个数组
            parseData = [NSArray yy_modelArrayWithClass:parseClass json:responseObject];
        } else {
            //返回其他数据结构
            if ([parseClass respondsToSelector:@selector(yy_modelWithJSON:)]) {
                parseData = [parseClass yy_modelWithJSON:responseObject];
            }
        }
        
        if (parseData) {
            //解析成功
            *error = nil;
            return parseData;
        } else {
            //解析失败
            *error = [NSString stringWithFormat:@"数据解析失败:%@", NSStringFromClass(parseClass)];
            return nil;
        }
    } else {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //If an error occurs, whether on the server or client side, the error message(s) will be returned in an errors array.
            NSArray *errorArray = [(NSDictionary *)responseObject valueForKey:@"errors"];
            if (errorArray) {
                //返回数据存在错误
                NSMutableString *erreStr = [[NSMutableString alloc] init];
                for (NSString *str in errorArray) {
                    [erreStr appendString:[NSString stringWithFormat:@"%@\n", str]];
                }
                *error = erreStr;
                return nil;
            }
        }
        
        //数据正常
        *error = nil;
        return responseObject;
    }
}
@end

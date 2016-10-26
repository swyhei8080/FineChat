//
//  NSURLRequest+Params.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "NSURLRequest+Params.h"

static const void *baseUrlKey;
static const void *requestPathKey;
static const void *additionalParamsKey;
static const void *requestParamsKey;
static const void *expireTimeKey;

@implementation NSURLRequest (Params)

- (void)setBaseUrl:(NSString *)baseUrl
{
    objc_setAssociatedObject(self, &baseUrlKey, baseUrl, OBJC_ASSOCIATION_COPY);
}

- (NSString *)baseUrl
{
    return objc_getAssociatedObject(self, &baseUrlKey);
}

- (void)setRequestPath:(NSString *)requestPath
{
    objc_setAssociatedObject(self, &requestPathKey, requestPath, OBJC_ASSOCIATION_COPY);
}

- (NSString *)requestPath
{
    return objc_getAssociatedObject(self, &requestPathKey);
}

- (void)setAdditionalParams:(NSDictionary *)additionalParams
{
    objc_setAssociatedObject(self, &additionalParamsKey, additionalParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)additionalParams
{
    return objc_getAssociatedObject(self, &additionalParamsKey);
}

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &requestParamsKey, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &requestParamsKey);
}

- (void)setExpireTime:(NSTimeInterval)expireTime
{
    objc_setAssociatedObject(self, &expireTimeKey, @(expireTime), OBJC_ASSOCIATION_COPY);
}

- (NSTimeInterval)expireTime
{
    NSNumber *expireTime = objc_getAssociatedObject(self, &expireTimeKey);
    return [expireTime doubleValue];
}

//- (id)mas_key {
//    return objc_getAssociatedObject(self, @selector(mas_key));
//}
//
//- (void)setMas_key:(id)key {
//    objc_setAssociatedObject(self, @selector(mas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

@end

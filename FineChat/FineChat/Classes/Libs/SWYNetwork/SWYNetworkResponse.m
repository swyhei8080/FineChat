//
//  SWYNetworkResponse.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkResponse.h"
#import "NSURLRequest+Params.h"

//调用api的发送请求方法,但没有真正发送请求时返回的请求标识符,如请求创建失败,从缓存中获取
NSInteger const kRequestIdWhenNoRealSend= -90;

//创建NSRequest失败时SWYNetworkResponse的状态码
NSInteger const kCreateRequestFailureStatusCode = -100;

//从缓存中获取的SWYNetworkResponse的状态码
NSInteger const kCacheStatusCode = -110;

@interface SWYNetworkResponse ()

@end

@implementation SWYNetworkResponse

- (instancetype)initWithData:(NSData *)responseData statusCode:(NSInteger)statusCode error:(NSError *)error cached:(BOOL)cache expire:(NSTimeInterval)expireTime cacheKey:(NSString *)key
{
    if (self = [super init]) {
        _responseData = responseData;
        _responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (responseData) {
            _responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }
        
        _statusCode = statusCode;
        _error = error;
        _cache = cache;
        _expireTime = expireTime;
        _cacheKey = key;
    }
    
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    SWYNetworkResponse *obj = [[[self class] allocWithZone:zone] init];
    obj.responseData = self.responseData;
    obj.responseString = self.responseString;
    obj.responseObject = self.responseObject;
    
    obj.statusCode = self.statusCode;
    obj.error = self.error;
    
    obj.cache = self.isCache;
    obj.expireTime = self.expireTime;
    obj.cacheKey = self.cacheKey;
    
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SWYNetworkResponse *obj = [[[self class] allocWithZone:zone] init];
    return obj;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_responseData forKey:@"responseData"];
    [aCoder encodeObject:_responseString forKey:@"responseString"];
    [aCoder encodeObject:_responseObject forKey:@"responseObject"];
    
    [aCoder encodeInteger:_statusCode forKey:@"statusCode"];
    [aCoder encodeObject:_error forKey:@"error"];
    
    [aCoder encodeBool:_cache forKey:@"cache"];
    [aCoder encodeDouble:_expireTime forKey:@"expireTime"];
    [aCoder encodeObject:_cacheKey forKey:@"cacheKey"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    _responseData = [aDecoder decodeObjectForKey:@"responseData"];
    _responseString = [aDecoder decodeObjectForKey:@"responseString"];
    _responseObject = [aDecoder decodeObjectForKey:@"responseObject"];
    
    
    _statusCode = [aDecoder decodeIntegerForKey:@"statusCode"];
    _error = [aDecoder decodeObjectForKey:@"error"];
    
    _cache = [aDecoder decodeBoolForKey:@"cache"];
    _expireTime = [aDecoder decodeDoubleForKey:@"expireTime"];
    _cacheKey = [aDecoder decodeObjectForKey:@"cacheKey"];
    
    return self;
}

@end

//
//  SWYNetworkCacheManager.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkCacheManager.h"
#import "SWYNetworkUtil.h"
#import "SWYNetworkBaseAPI.h"
#import "SWYNetworkResponse.h"
#import "SWYNetworkConfiguration.h"

#define kCacheData        @"cacheData"
#define kCacheTime        @"cacheTime"
#define kCacheExpireTime  @"expireTime"
#define kCacheKey         @"cacheKey"

@interface SWYNetworkCacheManager ()<NSCacheDelegate>

@property (strong, nonatomic) NSCache *ntCache;

@end

@implementation SWYNetworkCacheManager

+ (instancetype)sharedInstance
{
    static SWYNetworkCacheManager *cacheManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cacheManager = [[SWYNetworkCacheManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:cacheManager selector:@selector(clearMemoryCache)name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    });
    
    return cacheManager;
}

- (NSCache *)ntCache
{
    if (!_ntCache) {
        _ntCache = [[NSCache alloc] init];
        _ntCache.countLimit = 100;
        _ntCache.delegate = self;
    }
    
    return _ntCache;
}

- (void)clearAllCache
{
    [self clearMemoryCache];
    [self clearFileCache];
}

- (void)clearMemoryCache
{
    [self.ntCache removeAllObjects];
}

- (void)clearFileCache
{
    NSString *cacheDirectory = [self getCacheDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheDirectory]) {
        [fileManager removeItemAtPath:cacheDirectory error:NULL];
    }
}

- (void)cacheData:(SWYNetworkResponse *)response forKey:(NSString *)key
{
    FCLog1(@"对数据进行二级缓存");
    [[SWYNetworkCacheManager sharedInstance] cacheToMemory:response forKey:key];
    [[SWYNetworkCacheManager sharedInstance] cacheToFile:response forKey:key];
}

- (SWYNetworkResponse *)responseFromCache:(NSString *)key
{
    SWYNetworkResponse *response = [self responseFromMemoryCache:key];
    
    if (!response) {
        response = [self responseFromFileCache:key];
    }
    
    if (!response) {
        FCLog1(@"没有缓存数据");
    }
    
    return response;
}

- (void)cacheToMemory:(SWYNetworkResponse *)response forKey:(NSString *)key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[kCacheData] = response.responseData;
    dict[kCacheExpireTime] = @(response.expireTime);
    dict[kCacheKey] = key;
    dict[kCacheTime] = [NSDate date];
    [self.ntCache setObject:dict forKey:key];
}

- (SWYNetworkResponse *)responseFromMemoryCache:(NSString *)key
{
    NSMutableDictionary *dict = [self.ntCache objectForKey:key];
    
    NSDate *cacheDate = dict[kCacheTime];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:cacheDate];
    NSTimeInterval expire = [dict[kCacheExpireTime] doubleValue];
    if (seconds > expire ) {
        FCLog1(@"内存中的缓存过期了");
        return nil;
    }
    
    SWYNetworkResponse *response = [[SWYNetworkResponse alloc] initWithData:dict[kCacheData]
                                                               statusCode:kCacheStatusCode
                                                                    error:nil
                                                                   cached:YES
                                                                   expire:[dict[kCacheExpireTime] doubleValue]
                                                                 cacheKey:dict[kCacheKey]];
    FCLog1(@"获得内存中的缓存");
    return response;
}

- (void)cacheToFile:(SWYNetworkResponse *)response forKey:(NSString *)key
{
    NSString *cacheFile = [[self getCacheDirectory] stringByAppendingPathComponent:key];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[kCacheData] = response.responseData;
    dict[kCacheExpireTime] = @(response.expireTime);
    dict[kCacheKey] = key;
    dict[kCacheTime] = [NSDate date];
    
    [NSKeyedArchiver archiveRootObject:dict toFile:cacheFile];
}

- (SWYNetworkResponse *)responseFromFileCache:(NSString *)key
{
    NSString *cacheFile = [[self getCacheDirectory] stringByAppendingPathComponent:key];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile];
    
    NSDate *cacheDate = dict[kCacheTime];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:cacheDate];
    NSTimeInterval expire = [dict[kCacheExpireTime] doubleValue];
    if (seconds > expire ) {
        FCLog1(@"文件中的缓存过期了");
        return nil;
    }
    
    SWYNetworkResponse *response = [[SWYNetworkResponse alloc] initWithData:dict[kCacheData]
                                                               statusCode:kCacheStatusCode
                                                                    error:nil
                                                                   cached:YES
                                                                   expire:[dict[kCacheExpireTime] doubleValue]
                                                                 cacheKey:dict[kCacheKey]];
    
    FCLog1(@"获得文件中的缓存");
    return response;
}

- (NSString *)getCacheDirectory
{
    NSString *sysCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [sysCachePath stringByAppendingPathComponent:@"networkCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    if ([fileManager fileExistsAtPath:cachePath isDirectory:&isDir]) {
        if (!isDir) {
            [fileManager removeItemAtPath:cachePath error:NULL];
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }else{
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return cachePath;
}

- (NSString *)cacheKeyWithParams:(NSDictionary *)requestParams
                additionalParams:(NSDictionary *)additionalParams
                         baseUrl:(NSString *)baseUrl
                     requestPath:(NSString *)requestPath
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if (baseUrl && baseUrl.length > 0) {
        [str appendString:baseUrl];
    }
    
    if (requestPath && requestPath.length > 0) {
        [str appendString:requestPath];
    }
    
    if (requestParams) {
        [str appendString:[SWYNetworkUtil getParamsStringFromParamsDict:requestParams]];
    }
    
    if (additionalParams) {
        [str appendString:[SWYNetworkUtil getParamsStringFromParamsDict:additionalParams]];
    }
    
    NSString *cacheKey = [SWYNetworkUtil md5String:str];
    
    FCLog1(@"缓存key--%@",cacheKey);
    
    return cacheKey;
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    FCLog1(@"缓存数据被释放%@",obj);
}

@end
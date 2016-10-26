//
//  SWYNetworkCacheManager.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWYNetworkBaseAPI,SWYNetworkResponse;

@interface SWYNetworkCacheManager : NSObject

+ (instancetype)sharedInstance;

- (void)clearAllCache;

- (void)clearMemoryCache;

- (void)clearFileCache;

- (NSString *)cacheKeyWithParams:(NSDictionary *)requestParams
                additionalParams:(NSDictionary *)additionalParams
                         baseUrl:(NSString *)baseUrl
                     requestPath:(NSString *)requestPath;

/**
 *  把数据同时缓存到内存缓存与文件缓存中
 */
- (void)cacheData:(SWYNetworkResponse *)response forKey:(NSString *)key;

/**
 *  先从内存缓存中获取数据,如果失败则去文件缓存中获取,都失败返回nil;
 */
- (SWYNetworkResponse *)responseFromCache:(NSString *)key;


//- (void)cacheToMemory:(SWYNetworkResponse *)response forKey:(NSString *)key;
//
//- (SWYNetworkResponse *)responseFromMemoryCache:(NSString *)key;
//
//- (void)cacheToFile:(SWYNetworkResponse *)response forKey:(NSString *)key;
//
//- (SWYNetworkResponse *)responseFromFileCache:(NSString *)key;

@end

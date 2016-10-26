//
//  SWYNetworkResponse.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWYNetworkResponse : NSObject<NSCopying,NSCoding>

/**服务器返回的原始数据*/
@property (strong, nonatomic) NSData *responseData;

/**由原始数据转换成的字符串形式的数据*/
@property (copy, nonatomic) NSString *responseString;

/**由原始数据转换成的josn数据,如果返回的不是json格式的数据,则为nil*/
@property (copy, nonatomic) id responseObject;

//@property (nonatomic, strong) NSDictionary *responseHeaders;

/**响应状态码*/
@property (assign, nonatomic) NSInteger statusCode;

/**如果出错,不为空*/
@property (assign, nonatomic) NSError *error;

/**是否是缓存的数据,从缓存中获取时,为yes,否则为no*/
@property (assign, nonatomic, getter=isCache) BOOL cache;

/**缓存过期时长,只有缓存时才有用*/
@property (assign, nonatomic) NSTimeInterval expireTime;

/**缓存key,只有缓存时才有用*/
@property (copy, nonatomic) NSString *cacheKey;

/**下载文件的存储路径,只在下载文件时才有值*/
@property (strong, nonatomic) NSURL *downloadFilePath;

/**与这个响应对象对应的请求的参数*/
@property (copy, nonatomic)NSDictionary *requestParams;

/**
 *  初始化一个SWYNetworkResponse对象
 *
 *  @param responseData 服务器返回的NSData数据
 *  @param statusCode   响应状态码
 *  @param error
 *  @param cache        用于表示该对象是否是缓存数据,从缓存中获取时,为yes,否则为no
 *  @param expireTime   缓存的最大时长,单位为秒,如果不是缓存中的数据,可设置为0或者负数
 *  @param key          缓存数据时用的key
 *
 *  @return SWYNetworkResponse对象
 */
- (instancetype)initWithData:(NSData *)responseData
                  statusCode:(NSInteger)statusCode
                       error:(NSError *)error
                      cached:(BOOL)cache
                      expire:(NSTimeInterval)expireTime
                    cacheKey:(NSString *)key;

@end

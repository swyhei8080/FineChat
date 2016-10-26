//
//  SWYNetworkProxy.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWYNetworkConfiguration.h"
@class SWYNetworkResponse,SWYNetworkBaseAPI;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProxySuccessBlock)(SWYNetworkResponse *response, NSNumber *requestId);
typedef void(^ProxyFailureBlock)(SWYNetworkResponse *response, NSNumber *requestId);
typedef void(^ProxyProgressBlock)(NSProgress *progress);

@interface SWYNetworkProxy : NSObject

+ (instancetype)sharedInstance;

/**
 * 调用AFNetworking发送请求
 */
- (NSNumber *)startRequestWith:(SWYNetworkBaseAPI *)baseApi
                      progress:(_Nullable ProxyProgressBlock)progressBlock
                       success:(_Nullable ProxySuccessBlock)successBlock
                       failure:(_Nullable ProxySuccessBlock)failureBlock;

/**
 *  取消单个请求
 *
 *  @param requestId 请求id
 */
- (void)cancelRequestWithId:(NSNumber *)requestId;

/**
 *  取消多个请求
 *
 *  @param requestIds 请求id数组
 */
- (void)cancelRequestsWithIds:(NSArray *)requestIds;

/**
 *  网络状态
 */
- (SWYNetworkReachabilityStatus)reachabilityStatus;

@end

NS_ASSUME_NONNULL_END

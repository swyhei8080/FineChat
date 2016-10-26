//
//  SWYNetworkBaseAPI.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkBaseAPI.h"
#import "SWYNetworkResponse.h"
#import "SWYNetworkProxy.h"
#import "SWYNetworkCacheManager.h"
#import "NSURLRequest+Params.h"

@interface SWYNetworkBaseAPI ()

@property (copy, nonatomic) NSMutableArray *requestIdArray;

@property (assign, nonatomic, readwrite, getter=isLoading)BOOL loading;

@end

@implementation SWYNetworkBaseAPI

-(void)dealloc
{
    FCLog(@"\t%s\n\t%s\n\t%@,",__FILE__,__func__,@"释放了吗");
}

- (NSMutableArray *)requestIdArray
{
    if (!_requestIdArray) {
        _requestIdArray = [[NSMutableArray alloc] init];
    }
    
    return _requestIdArray;
}

- (BOOL)isLoading
{
    if (self.requestIdArray.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 发送请求方法
- (NSNumber *)startRequestWithProgressBlock:(SWYRequestProgressCallBack)downOrUploadProgressBlock
                            successCallBack:(SWYRequestSuccessCallBack)successCallback
                            failureCallBack:(SWYRequestFailureCallBack)failureCallBack
{
    //发送请求前拦截
    BOOL shouldCallBackIn = [self beforeStartRequest];
    BOOL shouldCallBackOut = YES;
    if ([self.interceptor respondsToSelector:@selector(networkApiBeforeStartRequest:)]) {
        shouldCallBackOut = [self.interceptor networkApiBeforeStartRequest:self];
    }
    
    if (!shouldCallBackIn || !shouldCallBackOut) {
        return @(kRequestIdWhenNoRealSend);
    }
    
    //加载缓存
    if ([self shouldLoadCache]) {
        NSString *key = [[SWYNetworkCacheManager sharedInstance] cacheKeyWithParams:[self requestParams]
                                                                  additionalParams:[self additionalParams]
                                                                           baseUrl:[self baseUrl]
                                                                       requestPath:[self requestPath]];
        
        SWYNetworkResponse *response = [[SWYNetworkCacheManager sharedInstance] responseFromCache:key];
        response.requestParams = [self requestParams];
        
        if (response) {
            [self didSuccessHandle:response callback:successCallback];
            return @(kRequestIdWhenNoRealSend);
        }
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSNumber *requestIdentity = [[SWYNetworkProxy sharedInstance] startRequestWith:self progress:^(NSProgress * _Nonnull progress) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            //进度处理
            if (downOrUploadProgressBlock) {
                downOrUploadProgressBlock(progress);
            }
            
            if ([self.delegate respondsToSelector:@selector(networkApi:requestProgress:)]) {
                [self.delegate networkApi:self requestProgress:progress];
            }
        }
        
    } success:^(SWYNetworkResponse * _Nonnull response,  NSNumber * _Nonnull requestId) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            //请求成功处理
            [strongSelf.requestIdArray removeObject:requestId];
            [strongSelf didSuccessHandle:response callback:successCallback];
        }
        
    } failure:^(SWYNetworkResponse * _Nonnull response, NSNumber * _Nonnull requestId) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            //请求失败处理
            [strongSelf.requestIdArray removeObject:requestId];
            [strongSelf didFailureHandle:response callback:failureCallBack];
        }
        
    }];
    
    if ([requestIdentity integerValue] != kRequestIdWhenNoRealSend) {
        [self.requestIdArray addObject:requestIdentity];
    }
    
    return requestIdentity;
}

#pragma mark - 请求用到的参数方法

- (NSString *)baseUrl
{
    return nil;
}

- (NSString *)requestPath
{
    return nil;
}

- (NSDictionary<NSString *, NSString *> *)requestHeadFields
{
    return nil;
}

- (NSDictionary *)additionalParams
{
    return nil;
}

- (NSDictionary *)requestParams
{
    return nil;
}

- (SWYNetworkRequestType)requestType
{
    return SWYNetworkRequestTypePost;
}

- (BOOL)shouldCache
{
    return NO;
}

- (BOOL)shouldLoadCache
{
    return NO;
}

- (NSTimeInterval)expireTime
{
    return kCacheExpireTime;
}

- (NSURL *)fileDownloadDirURL
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return documentsDirectoryURL;
}

//- (SWYConstructingBodyBlock)constructingBodyBlock
//{
//    return nil;
//}

- (NSArray <SWYNetworkFile *>*)multiPartArray
{
    return nil;
}

#pragma mark - 取消方法
- (void)cancelAllRequest
{
    [[SWYNetworkProxy sharedInstance] cancelRequestsWithIds:self.requestIdArray];
    
    [self.requestIdArray removeAllObjects];
}

- (void)cancelSingleRequestWithId:(NSNumber *)requestId
{
    [[SWYNetworkProxy sharedInstance] cancelRequestWithId:requestId];
    
    [self.requestIdArray removeObject:requestId];
}

#pragma mark - 网络状态相关
- (SWYNetworkReachabilityStatus)networkStatus
{
    return [[SWYNetworkProxy sharedInstance] reachabilityStatus];
}

#pragma mark - 回调完成或失败后的处理方法
- (void)didSuccessHandle:(SWYNetworkResponse *)response callback:(SWYRequestSuccessCallBack)successBlock
{
    BOOL shouldCallBackIn = [self beforeSuccessCallBack:response];
    BOOL shouldCallBackOut = YES;
    if ([self.interceptor respondsToSelector:@selector(networkApi:beforeSuccessCallBack:)]) {
        shouldCallBackOut = [self.interceptor networkApi:self beforeSuccessCallBack:response];
    }
    
    if (!shouldCallBackIn || !shouldCallBackOut) {
        return;
    }
    
    if ([self shouldCache] && !response.isCache) {
#warning TODO
        //验证方法还未写
        
        [[SWYNetworkCacheManager sharedInstance] cacheData:response forKey:response.cacheKey];
    }
    
    if (successBlock) {
        successBlock(self,response);
    }
    
    if ([self.delegate respondsToSelector:@selector(networkApi:requestDidSuccess:)]) {
        [self.delegate networkApi:self requestDidSuccess:response];
    }
    
    [self afterSuccessCallBack:response];
    if ([self.interceptor respondsToSelector:@selector(networkApi:afterSuccessCallBack:)]) {
        [self.interceptor networkApi:self afterSuccessCallBack:response];
    }
}

- (void)didFailureHandle:(SWYNetworkResponse *)response callback:(SWYRequestFailureCallBack)failureBlock
{
    BOOL shouldCallBackIn = [self beforeFailureCallBack:response];
    BOOL shouldCallBackOut = YES;
    if ([self.interceptor respondsToSelector:@selector(networkApi:beforeFailureCallBack:)]) {
        shouldCallBackOut = [self.interceptor networkApi:self beforeFailureCallBack:response];
    }
    
    if (!shouldCallBackIn || !shouldCallBackOut) {
        return;
    }
    
    if (failureBlock) {
        failureBlock(self,response);
    }
    
    if ([self.delegate respondsToSelector:@selector(networkApi:requestDidFailure:)]) {
        [self.delegate networkApi:self requestDidFailure:response];
    }
    
    [self afterFailureCallBack:response];
    if ([self.interceptor respondsToSelector:@selector(networkApi:afterFailureCallBack:)]) {
        [self.interceptor networkApi:self afterFailureCallBack:response];
    }
}

#pragma mark - 内部拦截方法
- (BOOL)beforeStartRequest
{
    FCLog1(@"拦截方法beforStartRequest");
    return YES;
}

- (BOOL)beforeSuccessCallBack:(SWYNetworkResponse *)response
{
    FCLog1(@"拦截方法beforeSuccessCallBack");
    return YES;
}

- (void)afterSuccessCallBack:(SWYNetworkResponse *)response
{
    FCLog1(@"拦截方法afterSuccessCallBack");
}

- (BOOL)beforeFailureCallBack:(SWYNetworkResponse *)response
{
    FCLog1(@"拦截方法beforeFailureCallBack");
    return YES;
}

- (void)afterFailureCallBack:(SWYNetworkResponse *)response
{
    FCLog1(@"拦截方法afterFailureCallBack");
}
@end

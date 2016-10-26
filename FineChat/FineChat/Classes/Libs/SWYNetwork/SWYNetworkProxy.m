//
//  SWYNetworkProxy.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkProxy.h"
#import "SWYNetworkResponse.h"
#import "SWYNetworkBaseAPI.h"
#import "SWYNetworkUtil.h"
#import "NSURLRequest+Params.h"
#import "SWYNetworkCacheManager.h"
#import "SWYNetworkFile.h"


NSString * const SWYNetworkingReachabilityNotification = @"SWYNetworkingReachabilityNotification";
NSString * const SWYNetworkingReachabilityStatus = @"SWYNetworkingReachabilityStatus";

@interface SWYNetworkProxy ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (copy, nonatomic) NSMutableDictionary<NSNumber *, NSURLSessionTask *> *requestRecords;

@property (copy, nonatomic) NSMutableDictionary<NSNumber *, SWYNetworkBaseAPI *> *apiRecords;

@property (assign, atomic) NSUInteger lastRequestId;

@end

@implementation SWYNetworkProxy

+ (instancetype)sharedInstance
{
    static SWYNetworkProxy *networkProxy = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        networkProxy = [[SWYNetworkProxy alloc] init];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSDictionary *userInfo = @{ SWYNetworkingReachabilityStatus: @(status) };
            [[NSNotificationCenter defaultCenter] postNotificationName:SWYNetworkingReachabilityNotification object:nil userInfo:userInfo];
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return networkProxy;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        
//        如果是https,要开启这个 not recommended for production
//        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = kRequestTimeoutInterval;
        //        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        /*默认就是NSUTF8StringEncoding,AF只对传入的参数字典进行编码,头部字段与直接传入的url不会帮我们编码,如www.abc.com:8080/servlet?a=值,因为这是直接传入的url,所以不会进行编码,因此会报错,但如果传入一个@{@"a":@"值"},则会进行编码.当请求方式是get时,直接传入的url,同样不会进行编码.可以去查看AF源码
         - (NSMutableURLRequest *)requestWithMethod:(NSString *)method
         URLString:(NSString *)URLString
         parameters:(id)parameters
         error:(NSError *__autoreleasing *)error
         */
        
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _manager.requestSerializer = requestSerializer;
        _manager.responseSerializer = responseSerializer;
        
        _lastRequestId = 0;
        
        _requestRecords = [[NSMutableDictionary alloc] init];
        _apiRecords = [[NSMutableDictionary alloc] init];
    }
    
    return _manager;
}

#pragma mark - 发送请求
/**
 *  发送请求
 */
- (NSNumber *)startRequestWith:(SWYNetworkBaseAPI *)baseApi
                      progress:(ProxyProgressBlock)progressBlock
                       success:(ProxySuccessBlock)successBlock
                       failure:(ProxySuccessBlock)failureBlock
{
    FCLog1(@"进入开始发送请求方法");
    
    NSUInteger currentRequestId;
    @synchronized (self) {
        if (10000 == self.lastRequestId) {
            self.lastRequestId = 0;
            currentRequestId = 0;
        }else{
            currentRequestId = ++self.lastRequestId;
        }
    }
    
    NSError *requestError = nil;
    
    NSMutableURLRequest *request = [self createRequestWithBaseApi:baseApi error:&requestError];
    if (requestError) {
        SWYNetworkResponse *errorResponse = [[SWYNetworkResponse alloc] initWithData:nil
                                                                        statusCode:kCreateRequestFailureStatusCode
                                                                             error:requestError
                                                                            cached:NO
                                                                            expire:0
                                                                          cacheKey:nil];
        if (failureBlock) {
            failureBlock(errorResponse,@(kRequestIdWhenNoRealSend));
        }
        
        return @(kRequestIdWhenNoRealSend);
    }
    
    NSURLSessionTask *task = nil;
    
    SWYNetworkRequestType requestType = [baseApi requestType];
    
    //只有上传文件或下载文件时才使用进度
    if (requestType == SWYNetworkRequestTypeGet || requestType == SWYNetworkRequestTypePost || requestType == SWYNetworkRequestTypeHead || requestType == SWYNetworkRequestTypePut || requestType == SWYNetworkRequestTypeDelete || requestType == SWYNetworkRequestTypePatch) {
        
        FCLog1(@"发送数据请求");
        task = [self dataTaskWithRequest:request
                                progress:progressBlock
                                 success:successBlock
                                 failure:failureBlock
                               requestId:currentRequestId];
        
    }else if (requestType == SWYNetworkRequestTypeUploadFile){
        FCLog1(@"发送文件上传请求");
        task = [self uploadTaskWithRequest:request
                                  progress:progressBlock
                                   success:successBlock
                                   failure:failureBlock
                                 requestId:currentRequestId];
        
    }else if (requestType == SWYNetworkRequestTypeDownloadFile){
        FCLog1(@"发送文件下载请求");
        NSURL *downLoadDir = [baseApi fileDownloadDirURL];
        
        task = [self downloadTaskWithRequest:request
                                    progress:progressBlock
                                     success:successBlock
                                     failure:failureBlock
                                   requestId:currentRequestId
                                downloadPath:downLoadDir];
    }
    
    [self addRecord:currentRequestId task:task baseApi:baseApi];
    
    [task resume];
    
    return @(currentRequestId);
}

/**
 *  执行数据请求,progressBlock不会被使用
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)request
                                     progress:(ProxyProgressBlock)progressBlock
                                      success:(ProxySuccessBlock)successBlock
                                      failure:(ProxySuccessBlock)failureBlock
                                    requestId:(NSUInteger)requestId
{
    NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *key = [[SWYNetworkCacheManager sharedInstance] cacheKeyWithParams:request.requestParams
                                                                  additionalParams:request.additionalParams
                                                                           baseUrl:request.baseUrl
                                                                       requestPath:request.requestPath];
        
        SWYNetworkResponse *fcResponse = [[SWYNetworkResponse alloc] initWithData:responseData
                                                                     statusCode:httpResponse.statusCode
                                                                          error:error
                                                                         cached:NO
                                                                         expire:request.expireTime
                                                                       cacheKey:key];
        fcResponse.requestParams = request.requestParams;
        
        if (error) {
            if (failureBlock) {
                failureBlock(fcResponse,@(requestId));
            }
        }else{
            if (successBlock) {
                successBlock(fcResponse,@(requestId));
            }
        }
        
        //移除这个任务
        [self removeRecord:requestId];
        
    }];
    
    return dataTask;
    
}

/**
 *  执行文件上传请求
 */
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSMutableURLRequest *)request
                                         progress:(ProxyProgressBlock)progressBlock
                                          success:(ProxySuccessBlock)successBlock
                                          failure:(ProxySuccessBlock)failureBlock
                                        requestId:(NSUInteger)requestId
{
    NSURLSessionUploadTask *uploadTask = nil;
    
    uploadTask = [self.manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *key = [[SWYNetworkCacheManager sharedInstance] cacheKeyWithParams:request.requestParams
                                                                  additionalParams:request.additionalParams
                                                                           baseUrl:request.baseUrl
                                                                       requestPath:request.requestPath];
        
        SWYNetworkResponse *fcResponse = [[SWYNetworkResponse alloc] initWithData:responseData
                                                                     statusCode:httpResponse.statusCode
                                                                          error:error
                                                                         cached:NO
                                                                         expire:request.expireTime
                                                                       cacheKey:key];
        fcResponse.requestParams = request.requestParams;
        if (error) {
            if (failureBlock) {
                failureBlock(fcResponse,@(requestId));
            }
        }else{
            if (successBlock) {
                successBlock(fcResponse,@(requestId));
            }
        }
        
        //移除这个任务
        [self removeRecord:requestId];
    }];
    
    return uploadTask;
}

/**
 *  执行文件下载请求
 */
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSMutableURLRequest *)request
                                             progress:(ProxyProgressBlock)progressBlock
                                              success:(ProxySuccessBlock)successBlock
                                              failure:(ProxySuccessBlock)failureBlock
                                            requestId:(NSUInteger)requestId
                                         downloadPath:(NSURL *)downLoadDir
{
    NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [downLoadDir URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString *key = [[SWYNetworkCacheManager sharedInstance] cacheKeyWithParams:request.requestParams
                                                                  additionalParams:request.additionalParams
                                                                           baseUrl:request.baseUrl
                                                                       requestPath:request.requestPath];
        
        SWYNetworkResponse *fcResponse = [[SWYNetworkResponse alloc] initWithData:nil
                                                                     statusCode:httpResponse.statusCode
                                                                          error:error
                                                                         cached:NO
                                                                         expire:request.expireTime
                                                                       cacheKey:key];
        fcResponse.downloadFilePath = filePath;
        fcResponse.requestParams = request.requestParams;
        
        if (error) {
            if (failureBlock) {
                failureBlock(fcResponse,@(requestId));
            }
        }else{
            if (successBlock) {
                successBlock(fcResponse,@(requestId));
            }
        }
        
        //移除这个任务
        [self removeRecord:requestId];
        
    }];
    
    return downloadTask;
}

/**
 *  获取一个NSMutableURLRequest请求对象
 */
- (NSMutableURLRequest *)createRequestWithBaseApi:(SWYNetworkBaseAPI *)baseApi error:(NSError **)error
{
    FCLog1(@"创建请求对象");
    NSDictionary *params = [baseApi requestParams];
    NSDictionary *additionalParams = [baseApi additionalParams];
    NSString *baseUrl = [baseApi baseUrl];
    NSString *requestPath = [baseApi requestPath];
    
    [self configureRequestSerializerWithBaseApi:baseApi];
    AFHTTPRequestSerializer *requestSerializer = self.manager.requestSerializer;
    
    NSString *url = [self configureURLWithBaseApi:baseApi];
    
    NSMutableURLRequest *request = nil;
    
    if (baseApi.requestType == SWYNetworkRequestTypeGet) {
        request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypePost){
        request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypeHead){
        request = [requestSerializer requestWithMethod:@"HEAD" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypePut){
        request = [requestSerializer requestWithMethod:@"PUT" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypeDelete){
        request = [requestSerializer requestWithMethod:@"DELETE" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypePatch){
        request = [requestSerializer requestWithMethod:@"PATCH" URLString:url parameters:params error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypeUploadFile){
//        request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:[baseApi constructingBodyBlock] error:error];
        
          request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
              NSArray *multiPartArray = [baseApi multiPartArray];
              [multiPartArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  SWYNetworkFile *uploadfile = (SWYNetworkFile *)obj;
                  if (uploadfile.fileData != nil && uploadfile.fileData.length > 0) {
                      [formData appendPartWithFileData:uploadfile.fileData name:uploadfile.name fileName:uploadfile.fileName mimeType:uploadfile.mimeType];
                      
                  }else if (uploadfile.fileURL.length > 0){
                      NSURL *url = [[NSURL alloc] initWithString:uploadfile.fileURL];
                      [formData appendPartWithFileURL:url name:uploadfile.name fileName:uploadfile.fileName mimeType:uploadfile.mimeType error:error];
                  }else{
                      FCLog1(@".......上传的文件找不到........");
                  }
              }];
        } error:error];
        
    }else if (baseApi.requestType == SWYNetworkRequestTypeDownloadFile){
        request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:error];
    }
    
    request.baseUrl = baseUrl;
    request.requestPath = requestPath;
    request.additionalParams = additionalParams;
    request.requestParams = params;
    request.expireTime = [baseApi expireTime];
    
    return request;
}

/**
 *  设置请求头部字段
 */
- (void)configureRequestSerializerWithBaseApi:(SWYNetworkBaseAPI *)baseApi
{
    NSDictionary *headFields = [baseApi requestHeadFields];
    
    AFHTTPRequestSerializer *requestSerializer = self.manager.requestSerializer;
    for(id key in headFields){
        id value = headFields[key];
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            [requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}

/**
 *  根据api对象来拼接完整的url地址
 */
- (NSString *)configureURLWithBaseApi:(SWYNetworkBaseAPI *)baseApi
{
    NSDictionary *additionalParams = [baseApi additionalParams];
    NSString *baseUrl = [baseApi baseUrl];
    NSString *requestPath = [baseApi requestPath];
    
    NSString *url = nil;
    if ([requestPath hasPrefix:@"http"]) {
        url = requestPath;
    }else if ([requestPath hasPrefix:@"/"]){
        url = [NSString stringWithFormat:@"%@%@",baseUrl,requestPath];
    }else{
        url = [NSString stringWithFormat:@"%@/%@",baseUrl,requestPath];
    }
    
    if (additionalParams) {
        NSString *additionalStr = [SWYNetworkUtil getParamsStringFromParamsDict:additionalParams];
        if ([url rangeOfString:@"?"].location == NSNotFound) {
            url = [url stringByAppendingFormat:@"?%@",additionalStr];
        }else{
            url = [url stringByAppendingFormat:@"&%@",additionalStr];
        }
    }
    
    return url;
}

#pragma mark - 请求记录处理
/**
 *  保存请求记录
 */
- (void)addRecord:(NSUInteger)requestId task:(NSURLSessionTask *)task baseApi:(SWYNetworkBaseAPI *)baseApi
{
    @synchronized (self) {
        if (task && baseApi) {
            self.requestRecords[@(requestId)] = task;
            self.apiRecords[@(requestId)] = baseApi;
        }
    }
}

/**
 *  移除请求记录
 */
- (void)removeRecord:(NSUInteger)requestId
{
    @synchronized (self) {
        [self.requestRecords removeObjectForKey:@(requestId)];
        [self.apiRecords removeObjectForKey:@(requestId)];
    }
}

#pragma mark - 取消请求
- (void)cancelRequestWithId:(NSNumber *)requestId
{
    @synchronized (self) {
        NSURLSessionTask *task = self.requestRecords[requestId];
        if (task) {
            [task cancel];
            [self.requestRecords removeObjectForKey:requestId];
            [self.apiRecords removeObjectForKey:requestId];
        }
    }
}

- (void)cancelRequestsWithIds:(NSArray *)requestIds
{
    NSArray *ids = [requestIds copy];
    for (NSNumber *requestId in ids) {
        [self cancelRequestWithId:requestId];
    }
}

- (SWYNetworkReachabilityStatus)reachabilityStatus
{
    SWYNetworkReachabilityStatus status = SWYNetworkReachabilityStatusUnknown;
    AFNetworkReachabilityStatus afStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (afStatus) {
        case AFNetworkReachabilityStatusUnknown:
            status = SWYNetworkReachabilityStatusUnknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            status = SWYNetworkReachabilityStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            status = SWYNetworkReachabilityStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            status = SWYNetworkReachabilityStatusReachableViaWiFi;
            break;
    }
    
    return status;
}


@end

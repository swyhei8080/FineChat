//
//  SWYNetworkBaseAPI.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWYNetworkConfiguration.h"
@class SWYNetworkResponse,SWYNetworkBaseAPI,SWYNetworkFile;

//typedef void(^SWYConstructingBodyBlock)(id <AFMultipartFormData> formData);

typedef void(^SWYRequestSuccessCallBack)(SWYNetworkBaseAPI *api,SWYNetworkResponse *response);

typedef void(^SWYRequestFailureCallBack)(SWYNetworkBaseAPI *api,SWYNetworkResponse *response);

typedef void(^SWYRequestProgressCallBack)(NSProgress *progress);

#pragma mark - 请求回调协议SWYRequestCallBackDelegate
@protocol SWYRequestCallBackDelegate <NSObject>

- (void)networkApi:(SWYNetworkBaseAPI *)api requestDidSuccess:(SWYNetworkResponse *)response;

- (void)networkApi:(SWYNetworkBaseAPI *)api requestDidFailure:(SWYNetworkResponse *)response;

@optional
- (void)networkApi:(SWYNetworkBaseAPI *)api requestProgress:(NSProgress *)progress;

@end

#pragma mark - 拦截器协议SWYRequestInterceptDelegate-外部拦截方法
@protocol SWYRequestInterceptDelegate <NSObject>

@optional
//--------------内部拦截方法与外部拦截方法只要其中一个返回NO,当前这一步就不会继续进执行-------------//
- (BOOL)networkApiBeforeStartRequest:(SWYNetworkBaseAPI *)api;

- (BOOL)networkApi:(SWYNetworkBaseAPI *)api beforeSuccessCallBack:(SWYNetworkResponse *)response;

- (void)networkApi:(SWYNetworkBaseAPI *)api afterSuccessCallBack:(SWYNetworkResponse *)response;

- (BOOL)networkApi:(SWYNetworkBaseAPI *)api beforeFailureCallBack:(SWYNetworkResponse *)response;

- (void)networkApi:(SWYNetworkBaseAPI *)api afterFailureCallBack:(SWYNetworkResponse *)response;

@end


#pragma mark - SWYNetworkBaseAPI

@interface SWYNetworkBaseAPI : NSObject

/**请求完成或失败时的回调delegate*/
@property (weak, nonatomic) id<SWYRequestCallBackDelegate> delegate;

/**外部拦截器*/
@property (weak, nonatomic) id<SWYRequestInterceptDelegate> interceptor;

@property (assign, nonatomic, readonly, getter=isLoading)BOOL loading;

#pragma mark 请求用到的参数方法
//--------------------------------------子类根据需求重写以下的方法------------------//
/**请求的类型,总共有8种请求类型,默认为Post*/
- (SWYNetworkRequestType)requestType;

/**服务器地址,默认为*/
- (NSString *)baseUrl;

/**请求资源路径,默认为nil*/
- (NSString *)requestPath;

/**请求头部信息,默认为nil*/
- (NSDictionary<NSString *, NSString *> *)requestHeadFields;

/**请求的参数,默认为nil*/
- (NSDictionary *)requestParams;

/**扩展参数,扩展参数会被拼接到URL路径中,默认为nil*/
- (NSDictionary *)additionalParams;

/**是否要将服务器返回的数据缓存起来.默认为NO.只有当shouldCache为YES且通过有效性验证才会缓存*/
- (BOOL)shouldCache;

/**是否从缓存中加载数据.默认为NO*/
- (BOOL)shouldLoadCache;

/**如果有缓存,该缓存的有效时间,默认是kCacheExpireTime这个全局变量的值*/
- (NSTimeInterval)expireTime;

/**下载文件的保存路径*/
- (NSURL *)fileDownloadDirURL;

//- (SWYConstructingBodyBlock)constructingBodyBlock;

- (NSArray<SWYNetworkFile *>*)multiPartArray;

#pragma mark 发送请求方法
/**
 *  开始发送请求
 *
 *  @param downOrUploadProgressBlock 上传或下载文件进度发生变化时回调的block.只在请求类型为    SWYNetworkRequestTypeUploadFile,SWYNetworkRequestTypeDownloadFile时才有用,其他时候设置了也不会起作用,可设置为nil
 *  @param successCallback           数据请求完成时回调的block
 *  @param failureCallBack           请求失败时回调的block
 */
- (NSNumber *)startRequestWithProgressBlock:(SWYRequestProgressCallBack)downOrUploadProgressBlock
                            successCallBack:(SWYRequestSuccessCallBack)successCallback
                            failureCallBack:(SWYRequestFailureCallBack)failureCallBack;

#pragma mark 取消方法
- (void)cancelSingleRequestWithId:(NSNumber *)requestId;

- (void)cancelAllRequest;

/**获取网络状态*/
- (SWYNetworkReachabilityStatus)networkStatus;


#pragma mark 内部拦截方法
//--------------内部拦截方法与外部拦截方法只要其中一个返回NO,当前这一步就不会继续进执行-------------//
- (BOOL)beforeStartRequest;

- (BOOL)beforeSuccessCallBack:(SWYNetworkResponse *)response;

- (void)afterSuccessCallBack:(SWYNetworkResponse *)response;

- (BOOL)beforeFailureCallBack:(SWYNetworkResponse *)response;

- (void)afterFailureCallBack:(SWYNetworkResponse *)response;

@end

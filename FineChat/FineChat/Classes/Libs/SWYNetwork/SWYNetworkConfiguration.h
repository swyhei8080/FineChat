//
//  SWYNetworkConfiguration.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#ifndef SWYNetworkConfiguration_h
#define SWYNetworkConfiguration_h

typedef NS_ENUM(NSInteger, SWYNetworkRequestType) {
    SWYNetworkRequestTypeGet = 0,
    SWYNetworkRequestTypePost,
    SWYNetworkRequestTypeHead,
    SWYNetworkRequestTypePut,
    SWYNetworkRequestTypeDelete,
    SWYNetworkRequestTypePatch,
    SWYNetworkRequestTypeUploadFile,
    SWYNetworkRequestTypeDownloadFile
};

typedef NS_ENUM(NSInteger, SWYNetworkReachabilityStatus) {
    SWYNetworkReachabilityStatusUnknown = -1,
    SWYNetworkReachabilityStatusNotReachable = 0,
    SWYNetworkReachabilityStatusReachableViaWWAN = 1,
    SWYNetworkReachabilityStatusReachableViaWiFi = 2,
};

//-----------------网络可用性状态相关-----------------------------------//

/**网络状态发生改变时发出的通知*/
extern NSString * const SWYNetworkingReachabilityNotification;

/**网络状态发生改变发出的通知中,userInfo中代表状态的字段*/
extern NSString * const SWYNetworkingReachabilityStatus;



//-----------------网络请求状态相关-----------------------------------//

/**调用api的发送请求方法,但没有真正发送请求时返回的请求标识符,如请求创建失败,从缓存中获取*/
extern NSInteger const kRequestIdWhenNoRealSend;

/**创建NSRequest失败时SWYNetworkResponse的状态码*/
extern NSInteger const kCreateRequestFailureStatusCode;

/**从缓存中获取的SWYNetworkResponse的状态码*/
extern NSInteger const kCacheStatusCode;



//-----------------参数相关-----------------------------------//

static NSUInteger const kRequestTimeoutInterval = 30;

static NSUInteger const kCacheExpireTime = 300;

//static NSString * const kBaseUrl = @"http://192.168.2.117:8080";
//
//static NSString * const kOfflineBaseUrl = @"http://192.168.2.117:8080";



#endif /* SWYNetworkConfiguration_h */

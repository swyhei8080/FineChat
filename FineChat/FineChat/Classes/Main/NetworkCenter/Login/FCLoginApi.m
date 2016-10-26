//
//  FCLoginApi.m
//  FineChat
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginApi.h"

@implementation FCLoginApi

- (NSString *)requestPath
{
    return @"/FineChatServer/LoginServlet";
}

- (SWYNetworkRequestType)requestType
{
    return SWYNetworkRequestTypePost;
}

- (NSDictionary *)requestParams
{
    return self.params;
}

@end

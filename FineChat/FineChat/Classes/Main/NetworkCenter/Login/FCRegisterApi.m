//
//  RegisterApi.m
//  FineChat
//
//  Created by shi on 2016/10/19.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCRegisterApi.h"

@implementation FCRegisterApi

- (NSString *)requestPath
{
    return @"/FineChatServer/Register";
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

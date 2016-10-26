//
//  SmsVerifyAPI.m
//  FineChat
//
//  Created by shi on 2016/10/12.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCSmsVerifyAPI.h"

@implementation FCSmsVerifyAPI

- (NSString *)requestPath
{
    return @"/FineChatServer/CommitSMSCode";
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

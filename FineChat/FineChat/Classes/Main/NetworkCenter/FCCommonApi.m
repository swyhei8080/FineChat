//
//  CommonApi.m
//  FineChat
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCCommonApi.h"

#define kBaseUrl_online  @"http://192.168.1.102:8080"

#define kBaseUrl_offLine @"http://192.168.1.114:8080"

@implementation FCCommonApi

- (NSString *)baseUrl
{
    return kBaseUrl_offLine;
}

@end

//
//  LoginUser.m
//  FineChat
//
//  Created by shi on 16/6/16.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginUser.h"

@implementation FCLoginUser

+(instancetype)shareInstance
{
    static FCLoginUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[FCLoginUser alloc] init];
    });
    return user;
}

@end

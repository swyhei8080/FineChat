//
//  NSURLRequest+Params.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Params)

@property (copy, nonatomic) NSString *baseUrl;

@property (copy, nonatomic) NSString *requestPath;

@property (strong, nonatomic) NSDictionary *requestParams;

@property (strong, nonatomic) NSDictionary *additionalParams;

@property (assign, nonatomic) NSTimeInterval expireTime;

@end

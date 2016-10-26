//
//  SWYNetworkUtil.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWYNetworkUtil : NSObject

+ (NSString *)getParamsStringFromParamsDict:(NSDictionary *)aDict;

+ (NSString *)jsonStringFromArray:(NSArray *)jsonArray;

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)jsonDictionary;

+ (NSString *)md5String:(NSString *)aText;

+ (NSString *)paramsPercentEscapedStringFromString:(NSString *)string;

+ (NSString *)urlPathPercentEscapedStringFromString:(NSString *)string;

@end

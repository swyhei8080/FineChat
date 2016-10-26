//
//  SWYNetworkUtil.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SWYNetworkUtil

+ (NSString *)getParamsStringFromParamsDict:(NSDictionary *)aDict
{
    NSMutableString *paramsStr = [[NSMutableString alloc] init];
    for (id key in aDict) {
        id value = aDict[key];
        
        if (paramsStr.length <= 0) {
            [paramsStr appendFormat:@"%@=%@",[self paramsPercentEscapedStringFromString:key],[self paramsPercentEscapedStringFromString:value]];
        }else{
            [paramsStr appendFormat:@"&%@=%@",[self paramsPercentEscapedStringFromString:key],[self paramsPercentEscapedStringFromString:value]];
        }
    }
    
    return paramsStr;
}

+ (NSString *)jsonStringFromArray:(NSArray *)jsonArray
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)jsonDictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//大写的md5则只需将得到的加密字串转化成大写即可,[md5Str uppercaseString]
+ (NSString *)md5String:(NSString *)aText
{
    if (aText.length <= 0) {
        return nil;
    }
    const char *input = [aText UTF8String];
    unsigned char output[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(input, (CC_LONG)strlen(input), output);
    
    NSMutableString *md5Str = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5Str appendFormat:@"%02x",input[i]];
    }
    return md5Str;
}

/**
 Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
 - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
 - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
 
 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
 - parameter string: The string to be percent-escaped.
 - returns: The percent-escaped string.
 */

+ (NSString *)paramsPercentEscapedStringFromString:(NSString *)string
{
    //    static NSString * const kAFCharactersGeneralDelimitersToEncode = @"?/:#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    //    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    //
    //
    ////    :/?#[]@!$&'()*+,;=%
    //
    ////    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    ////    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

+ (NSString *)urlPathPercentEscapedStringFromString:(NSString *)string
{
    NSCharacterSet * allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~!*'();:@&=+$,/?#[]"];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}


@end

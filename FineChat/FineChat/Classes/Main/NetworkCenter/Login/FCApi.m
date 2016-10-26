//
//  FCApi.m
//  FineChat
//
//  Created by shi on 16/8/19.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCApi.h"

@implementation FCApi

//-(NSString *)baseUrl
//{
//    return @"http://192.168.2.119:8080";
//}

-(NSString *)requestPath
{
    return @"http://192.168.1.102:8080/FineChatServer/LoginServlet";
}

-(NSDictionary<NSString *, NSString *> *)requestHeadFields
{
//    NSString *str = @"值1";
//    NSString *result = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{
             @"fields1":@"fvalue1",
             @"fields2":@"fvalue2"
             };
}

-(NSDictionary *)additionalParams
{
//   return @{
//            @"addkey1":@"add值",
//            @"addkey2":@"addvalue2"
//            };
    return nil;
}

-(NSDictionary *)requestParams
{
//    NSString *s = @"啦啦";
//    
//    
//   NSString *b = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)s, NULL, (__bridge CFStringRef)s, kCFStringEncodingUTF8);
    
//    NSString *b = [s stringByAddingPercentEncodingWithAllowedCharacters:<#(nonnull NSCharacterSet *)#>];
    
    return @{
             @"userName":self.userName,
             @"passwd":self.pwd
             };
    
    return nil;
}

-(SWYNetworkRequestType)requestType
{
    return SWYNetworkRequestTypePost;
}

- (BOOL)shouldCache
{
    return NO;
}

- (BOOL)shouldLoadCache
{
    return NO;
}

//- (FCConstructingBodyBlock)constructingBodyBlock
//{
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *url = [documentPath stringByAppendingPathComponent:@"1.jpg"];
//    NSURL *urls = [NSURL fileURLWithPath:url];
//    
//    return ^(id <AFMultipartFormData> formData){
//        [formData appendPartWithFileURL:urls name:@"file" fileName:@"1.jpg" mimeType:@"image/jpeg" error:nil];
//        [formData appendPartWithFileURL:urls name:@"file" fileName:@"2.jpg" mimeType:@"image/jpeg" error:nil];
//        [formData appendPartWithFileURL:urls name:@"audio" fileName:@"3.jpg" mimeType:@"image/jpeg" error:nil];
//        [formData appendPartWithFileURL:urls name:@"image" fileName:@"4.jpg" mimeType:@"image/jpeg" error:nil];
//
//    };
//}

@end

//
//  FCSmsUtil.m
//  FineChat
//
//  Created by shi on 16/10/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCSmsUtil.h"
#import "SMSSDK.h"

@implementation FCSmsUtil

+ (void)getSMSCodeByPhoneNum:(NSString *)phoneNum
                        zone:(NSString *)zone
            customIdentifier:(NSString *)customIdentifier
                      result:(void(^)(NSError *error))result
{
    if (phoneNum.length <= 0) {
        
        NSError *err = [[NSError alloc] initWithDomain:@"cn.shiweiyin.FineChat.getSMSCodeError"
                                                  code:456
                                              userInfo:@{
                                                         @"getVerificationCode":@"手机号不能为空"
                                                         }];
        return result(err);
        
    }else if (zone.length <= 0){
        NSError *err = [[NSError alloc] initWithDomain:@"cn.shiweiyin.FineChat.error1"
                                                  code:456
                                              userInfo:@{
                                                         @"getVerificationCode":@"区号不能为空"
                                                         }];
        return result(err);
    }
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:zone customIdentifier:customIdentifier result:result];
}

+ (void)commitSMSCode:(NSString *)smsCode
          phoneNumber:(NSString *)phoneNum
                 zone:(NSString *)zone
               result:(void(^)(NSError *error))result
{
    if (phoneNum.length <= 0) {
        
        NSError *err = [[NSError alloc] initWithDomain:@"cn.shiweiyin.FineChat.getSMSCodeError"
                                                  code:456
                                              userInfo:@{
                                                         @"getVerificationCode":@"手机号不能为空"
                                                         }];
        return result(err);
        
    }else if (zone.length <= 0){
        NSError *err = [[NSError alloc] initWithDomain:@"cn.shiweiyin.FineChat.error1"
                                                  code:456
                                              userInfo:@{
                                                         @"getVerificationCode":@"区号不能为空"
                                                         }];
        return result(err);
    }
    
    [SMSSDK commitVerificationCode:smsCode phoneNumber:phoneNum zone:zone result:result];
}




@end

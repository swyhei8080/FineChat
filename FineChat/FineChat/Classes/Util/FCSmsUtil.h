//
//  FCSmsUtil.h
//  FineChat
//
//  Created by shi on 16/10/11.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSmsUtil : NSObject

+ (void)getSMSCodeByPhoneNum:(NSString *)phoneNum
                        zone:(NSString *)zone
            customIdentifier:(NSString *)customIdentifier
                      result:(void(^)(NSError *error))result;

+ (void)commitSMSCode:(NSString *)smsCode
          phoneNumber:(NSString *)phoneNum
                 zone:(NSString *)zone
               result:(void(^)(NSError *error))result;

@end

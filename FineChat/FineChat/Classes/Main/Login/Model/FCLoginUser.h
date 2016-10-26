//
//  LoginUser.h
//  FineChat
//
//  Created by shi on 16/6/16.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCLoginUser : NSObject

@property (copy,nonatomic) NSString *userName;

@property (copy,nonatomic) NSString *pwd;

+(instancetype)shareInstance;

@end

//
//  PromptUtil.h
//  FineChat
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface FCPromptUtil : NSObject

+ (void)showMessage:(NSString *)msg to:(UIView *)view;

+ (void)showCustomView:(UIView *)customView message:(NSString *)msg to:(UIView *)view;

/**
 *  mode不能是MBProgressHUDModeCustomView和MBProgressHUDModeText
 */
+ (MBProgressHUD *)showMessage:(NSString *)msg
                 detailMessage:(NSString *)detailMsg
                          mode:(MBProgressHUDMode)mode
                            to:(UIView *)view;

@end

//
//  PromptUtil.m
//  FineChat
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCPromptUtil.h"

@implementation FCPromptUtil

+ (void)showMessage:(NSString *)msg to:(UIView *)view
{
    UIView *targetView = view;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.mode = MBProgressHUDModeText;
    //默认margin是20;
    hud.margin = 10.0f;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    
    hud.yOffset = targetView.bounds.size.height / 2 - 50;
    
    [hud hide:YES afterDelay:1.5f];
}

+ (void)showCustomView:(UIView *)customView message:(NSString *)msg to:(UIView *)view
{
    UIView *targetView = view;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelText = msg;
    hud.customView = customView;
    
    [hud hide:YES afterDelay:1.5f];
}


+ (MBProgressHUD *)showMessage:(NSString *)msg
                 detailMessage:(NSString *)detailMsg
                          mode:(MBProgressHUDMode)mode
                            to:(UIView *)view
{
    if (mode == MBProgressHUDModeCustomView || mode == MBProgressHUDModeText) {
        return nil;
    }
    
    UIView *targetView = view;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = mode;
    
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelText = msg;
    hud.detailsLabelText = detailMsg;
    
    return hud;
    
}

@end

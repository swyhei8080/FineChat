//
//  SWYActionSheet.h
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWYActionSheet : UIView

/**
 *  点击按钮后的回调,第一个参数是点击按钮的tag,有cancel按钮时cancel为0,其它从上开始依次增加
 */
@property(copy)void(^actionSheetBlock)(NSInteger tag,NSString *btnTitle);

/**
 *  创建一个SWYActionSheet
 *
 *  @param cancel  取消按钮标题
 *  @param destroy 销毁按钮标题
 *  @param others  一般按钮标题,类型是NSArray
 *  @param msg     提示信息
 *
 *  @return 返回SWYActionSheet对象
 */
+(instancetype)addActionSheetWithCancelTitle:(NSString *)cancel
                                destroyTitle:(NSString *)destroy
                                  otherTitle:(NSArray *)others
                                     message:(NSString *)msg;

/**
 *  隐藏actionSheet
 */
-(void)hideActionSheet;

@end

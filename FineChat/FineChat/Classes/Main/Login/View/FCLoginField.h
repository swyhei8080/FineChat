//
//  FCLoginField.h
//  FineChat
//
//  Created by shi on 16/10/9.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCLoginField : UIView

/**文本输入框*/
@property (strong, nonatomic,readonly) UITextField *inputField;
/**是否允许输入,默认为YES,不允许*/
@property (assign, nonatomic) BOOL noEdit;

/**
 *  获得一个FCLoginField
 *
 *  @param title       左侧标题
 *  @param content     TextField的内容
 *  @param placeholder TextField的提示文本
 */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder;

@end

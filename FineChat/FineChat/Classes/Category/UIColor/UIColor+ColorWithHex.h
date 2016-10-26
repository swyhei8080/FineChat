//
//  UIColor+FC.h
//  FineChat
//
//  Created by shi on 16/8/4.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHex)

/**
 *  将输入的十六进制颜色转换成UIColor对象
 *
 *  @param hexColor 十六进制颜色字符串,可以有 "#" 也可以没有
 *
 *  @return 返回转换后的UIColor对象,如果格式不对,返回默认颜色:黑色
 */
+(nonnull UIColor *)colorWithHexColor:(nonnull NSString *)hexColor;

/**
 *  随机颜色
 */
+ (nonnull UIColor *)randomColor;

@end

//
//  UIColor+FC.m
//  FineChat
//
//  Created by shi on 16/8/4.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "UIColor+ColorWithHex.h"

@implementation UIColor (ColorWithHex)

#define kDefaultColor [UIColor blackColor]
+(UIColor *)colorWithHexColor:(NSString *)hexColor
{
    NSString *colorStr = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (colorStr.length < 6) {
        return kDefaultColor;
    }
    
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    if (colorStr.length != 6) {
        return kDefaultColor;
    }
    
    unsigned int red,green,blue;
    
    NSRange range = NSMakeRange(0, 2);
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
#undef kDefaultColor

//随机颜色
+ (UIColor *)randomColor
{
    CGFloat red = (arc4random() % 256 / 255.0);
    CGFloat green = (arc4random() % 256 / 255.0);
    CGFloat blue = (arc4random() % 256 / 255.0);
//    CGFloat alpha = (arc4random() % 255 / 255.0 );
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end

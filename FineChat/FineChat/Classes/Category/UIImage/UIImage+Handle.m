//
//  UIImage+Handle.m
//  FineChat
//
//  Created by shi on 2016/10/19.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "UIImage+Handle.h"

@implementation UIImage (Handle)

-(UIImage *)scaleImageToSize:(CGSize)size
                  scaleModel:(NSUInteger)model
                screenFactor:(NSUInteger)screenFactor
{
    //获得宽高的缩放比例
    CGFloat factorW = self.size.width / size.width;
    CGFloat factorH = self.size.height/size.height;
    
    CGFloat factorFinal;
    
    if(1 == model){
        factorFinal = (factorW > factorH?factorH:factorW);
    }else if (2 == model){
        factorFinal = (factorW > factorH?factorW:factorH);
    }
    
    //计算缩放后的图片大小
    CGFloat scaleWidth = self.size.width / factorFinal;
    CGFloat scaleHeight = self.size.height / factorFinal;
    
    //设置位置
    CGRect finalRect;
    
    if (1 == model){
        if (factorW > factorH) {
            finalRect = CGRectMake((size.width - scaleWidth)/2, 0, scaleWidth, scaleHeight);
        }else{
            finalRect = CGRectMake(0, (size.height - scaleHeight)/2, scaleWidth, scaleHeight);
        }
    }else if(2 == model){
        
        if (factorW > factorH) {
            finalRect = CGRectMake(0, (size.height - scaleHeight)/2, scaleWidth, scaleHeight);
        }else{
            finalRect = CGRectMake((size.width - scaleWidth)/2, 0, scaleWidth, scaleHeight);
        }
    }else{ //直接拉伸
        finalRect = CGRectMake(0, 0, size.width, size.height);
    }
    
    //重新绘制图片
    UIGraphicsBeginImageContextWithOptions(size, NO, screenFactor);
    [self drawInRect:finalRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end

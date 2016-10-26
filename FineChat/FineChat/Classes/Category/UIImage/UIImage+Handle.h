//
//  UIImage+Handle.h
//  FineChat
//
//  Created by shi on 2016/10/19.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handle)

/**
 * size:
 * 要缩放到的目标尺寸
 *
 * scaleMode:
 * 0:表示直接缩放,不按比例,与UIViewContentModeScaleToFill效果相似
 * 1:表示按小边缩放,按比例,与UIViewContentModeScaleAspectFill效果相似
 * 2:表示按大边缩放,按比例,与UIViewContentModeScaleAspectFit效果相似
 *
 * screenFactor:
 * 屏幕因子  1,2,3(plus),推荐用当前屏幕因子[UIScreen mainScreen].scale
 */
-(UIImage *)scaleImageToSize:(CGSize)size
                  scaleModel:(NSUInteger)model
                screenFactor:(NSUInteger)screenFactor;

@end

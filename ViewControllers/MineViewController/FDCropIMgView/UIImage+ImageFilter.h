//
//  UIImage+ImageFilter.h
//  研究图片的知识和处理加载框
//
//  Created by syf on 15/10/20.
//  Copyright (c) 2015年 SYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFilter)
/// 1. 截取图片上面的某一区域
- (UIImage *)SYFGetPartOfImageWithrect:(CGRect)partRect  WIthScaleSize:(CGSize)size;

/// 2. 给指定的uiview  截图
+ (UIImage *)SYFSnapshot:(UIView *)view;

///3,. 图片合成
+ (UIImage *)SYFMixIMgs:(UIImage *)bigIMg toImage:(UIImage *)smallImg;
@end

//
//  UIImage+ImageFilter.m
//  研究图片的知识和处理加载框
//
//  Created by syf on 15/10/20.
//  Copyright (c) 2015年 SYF. All rights reserved.
//
#define SYFWidth [UIScreen mainScreen].bounds.size.width
#define SYFHeight [UIScreen mainScreen].bounds.size.height

#import "UIImage+ImageFilter.h"

@implementation UIImage (ImageFilter)
/// 对图片进行剪裁
- (UIImage *)SYFGetPartOfImageWithrect:(CGRect)partRect  WIthScaleSize:(CGSize)size;
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
   CGImageRelease(imagePartRef);
    return [self scaleToSize:retImg size:size];
}

#pragma mark - Private method
+ (UIImage *)SYFSnapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

///  图片缩放到指定大小尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}


+ (UIImage *)SYFMixIMgs:(UIImage *)bigIMg toImage:(UIImage *)smallImg {
    UIGraphicsBeginImageContext(bigIMg.size);
    
    // Draw image1
    [bigIMg drawInRect:CGRectMake(0, 0, bigIMg.size.width, bigIMg.size.height)];
    
    // Draw image2
    CGFloat smallXX_, smallYY_;
    if(smallImg.size.width<smallImg.size.height){
        smallYY_ = 0;
        smallXX_ = bigIMg.size.width/2.0 - smallImg.size.width/2.0;
    }else{
        smallXX_ = 0;
        smallYY_ = bigIMg.size.height/2.0 - smallImg.size.height/2.0;
    }
    
    [smallImg drawInRect:CGRectMake(smallXX_, smallYY_, smallImg.size.width, smallImg.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end

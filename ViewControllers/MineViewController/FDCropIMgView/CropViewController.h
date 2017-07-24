//
//  CropViewController.h
//  防小红书 的图片剪切
//
//  Created by syf on 15/9/8.
//  Copyright (c) 2015年 SYF. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CropViewController : UIViewController
@property (strong, nonatomic) UIImage * IMg;

/** 剪切完毕后的 回调的block */
@property (copy, nonatomic) void(^cropIMGBlock)(UIImage *img) ;
@end

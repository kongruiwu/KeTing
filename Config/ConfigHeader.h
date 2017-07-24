//
//  ConfigHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h

#import "KTFactory.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "ToastView.h"
#import "AudioPlayer.h"
#import "UserManager.h"
//全局返回通用配置选项
typedef NS_ENUM(NSInteger, SelectorBackType){
    SelectorBackTypePopBack = 0,
    SelectorBackTypeDismiss,
    SelectorBackTypePoptoRoot
};
//返回键图片模式
typedef NS_ENUM(NSInteger,BackImgType){
    BackImgTypeNomal = 0,
    BackImgTypeWhite = 1,
    BackImgTypeBlack
};

//750状态下字体适配
#define font750(x) ((x)/ 1334.0f) * UI_HEGIHT
//750状态下像素适配宏
#define Anno750(x) ((x)/ 1334.0f) * UI_HEGIHT


#define UI_BOUNDS   [UIScreen mainScreen].bounds
#define UI_HEGIHT   [UIScreen mainScreen].bounds.size.height
#define UI_WIDTH    [UIScreen mainScreen].bounds.size.width


//规避空值
#define INCASE_EMPTY(str, replace) \
( ([(str) length]==0)?(replace):(str) )

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue,sec) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:sec]
//字体主色调  橙色
#define KTColor_MainOrange  UIColorFromRGB(0xcfaa5b)

#define KTColor_MainOrangeAlpha [UIColor colorWithRed:0.98 green:0.57 blue:0.01 alpha:0.3]
//标签橙色
#define KTColor_IconOrange  [UIColor colorWithRed:0.98 green:0.57 blue:0.01 alpha:1.00]

//字体主色调  黑色
#define KTColor_MainBlack   UIColorFromRGB(0x333333)
//字体浅灰色
#define KTColor_lightGray   UIColorFromRGB(0x999999)
//字体深灰色
#define KTColor_darkGray    UIColorFromRGB(0x666666)
//背景色
#define KTColor_BackGround  UIColorFromRGB(0xf2f2f2)
//线条色
#define KTColor_Line        [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00]
//金钱余额红色
#define KTColor_MoneyRed    [UIColor colorWithRed:1.00 green:0.33 blue:0.00 alpha:1.00]

// 播放器界面颜色
#define Audio_gray          UIColorFromRGB(0x52ffff)
#define Audio_progessWhite  [UIColor colorWithRed:0.88 green:0.87 blue:0.87 alpha:1.00]



#define     UmengKey            @"596eeee475ca35794b001d60"
#define     WxAppID             @"wx6c606ab1645ec900"
#define     WxAppSecret         @"01f9546287a51655a34fc114fe6d524b"
#define     JpushKey            @""
#define     APPID               @"1223784388"
#endif /* ConfigHeader_h */

//
//  commond.h
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^DelayBlock)(void);


@interface Commond : NSObject

/**
 *  @author wsh, 2016-07-22
 *
 *  @brief  调节html中的图片大小
 *
 *  @param strContent html字符串
 *
 *  @return 返回调整了图片大小的字符串
 */
+ (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent;

/**
 *  @author wsh, 2016-07-08
 *
 *  @brief 产生不重复的随机数
 *
 *  @param begin 开始值
 *  @param end   结束值
 *
 *  @return 返回的数组
 */
+ (NSArray *)randomArrayFromNum:(int)begin toNum:(int)end;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 判断当前网络状态
 *
 *  @return  0:没有网络连接 ; 1:使用3G网络 ; 2:使用WiFi网络
 */
+ (int)isWiFiOK;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 提供字符串类型的日期，转换成特定格式的日期返回
 *
 *  @param str 字符串类型的日期
 *
 *  @return 日期
 */
+ (NSDate *)dateFromString:(NSString *)str;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 时间对象转换为时间字段信息
 *
 *  @param date 日期类型
 *
 *  @return 返回NSDateComponents类型的数据
 */
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 将提供的字符串类型的日期转换成特定的格式返回
 *
 *  @param currentInt 提供的字符串类型的日期
 *
 *  @return 返回字符串类型的日期
 */
+ (NSString *)intTOTime:(NSString *)currentInt;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 根据键值存储数据
 *
 *  @param defaults 需要存储的数据
 *  @param key      存储数据的键值
 */
+ (void)setUserDefaults:(NSObject *)defaults forKey:(NSString *)key;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 根据键值获取数据
 *
 *  @param name 键值名
 *
 *  @return 返回数据
 */
+ (NSObject *)getUserDefaults:(NSString *)name;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 根据字符串的内容，字体大小以及宽度来计算其高度
 *
 *  @param text  字符串的内容
 *  @param font  字符串的字体大小
 *  @param width 字符串的宽度
 *
 *  @return 返回字符串的高度
 */
+ (CGFloat)calculateStringHeight:(NSString *)text withFont:(UIFont *)font withMaxWidth:(CGFloat)width;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 设置控制器在导航控制器上的标题
 *
 *  @param item 当前控制器的UINavigationItem
 *  @param str  设置的标题
 */
+ (void)naviTitle:(UINavigationItem *)item withString:(NSString *)str;

/**
 *  @author JopYin, 2016-07-07
 *
 *  设置个股详情页的导航栏的标题
 *
 *  @param item    当前控制器的UINavigationItem
 *  @param UpStr   股票的名称
 *  @param downStr 股票的代码
 */
+ (void)naviTitle:(UINavigationItem *)item withUpString:(NSString *)UpStr withDownString:(NSString *)downStr;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 给字符串加密
 *
 *  @param password 需要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)md5HexDigest:(NSString *)password;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 判断提供的字符串是不是手机号码
 *
 *  @param mobileNum 手机号码
 *
 *  @return 如果是电话号码就返回 YES , 不是就返回 NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  @author guofeng, 16-05-23 10:05:27
 *
 *  获取一个随机整数，范围在[from,to]，包括from，包括to
 *
 *  @param from  开始数字
 *  @param to    结束数字
 *
 *  @return 返回一个随机数字
 */
+ (NSInteger)getRandomNumber:(NSInteger)from To:(NSInteger)to;

/**
 *  @author guofeng, 16-05-23 15:05:29
 *
 *  MD5加密算法
 *
 *  @param UTF8String 字符串 char *
 *
 *  @return 字符串加密后的  NSString *
 */

+ (NSString *)md5String:(const char *)UTF8String;

/*
 *延迟若干时间后执行另外一个动作
 *
 *@FunctionName: RunAfterDelay：block
 *
 *@Author:guofeng
 *
 *@param: RunAfterDelay   延迟的秒数
 *@param: block           延迟之后要执行的内容
 *
 *@return:
 */
+ (void)RunAfterDelay:(NSTimeInterval )delay block: (DelayBlock)delayBlock;

/**
 *  @author wsh, 2016-06-24
 *
 *  @brief 将HTML5字符串格式转换成HTML5格式
 *
 *  @param htmlString HTML5字符串
 *
 *  @return HTML5格式字符
 */
+ (NSAttributedString *)getStringFromHTML5String:(NSString *)htmlString;

/**
 *  @author wsh, 2016-06-28
 *
 *  @brief 获取当前日期
 *
 *  @param format 格式
 *
 *  @return 返回当前日期
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;

@end

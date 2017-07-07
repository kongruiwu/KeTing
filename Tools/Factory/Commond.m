//
//  commond.m
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "Commond.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Reachability.h>

@implementation Commond

+ (NSArray *)randomArrayFromNum:(int)begin toNum:(int)end {
    // 随机数从这里边产生
    NSMutableArray *startArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < end; i++) {
        NSNumber *number = [NSNumber numberWithInt:i];
        [startArray addObject:number];
    }
    
    // 随机数产生结果
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 随机数个数
    NSInteger m = 8;
    
    if (end < 8) {
        m = end;
    }
    
    for (int i = 0; i < m; i++) {
        int t = arc4random()%startArray.count;
        resultArray[i] = startArray[t];
        startArray[t] = [startArray lastObject]; // 为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

/**
 *  @author guofeng, 16-05-20 14:05:25
 *
 *  md5加密处理
 *
 *  @param  UTF8String  加密前字符串
 *
 *  @return 加密后字符串（NSString）
 */
+ (NSString *)md5String:(const char *)UTF8String {
    const char *string = UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

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
+ (void) RunAfterDelay:(NSTimeInterval )delay block: (DelayBlock) delayBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay),
                   dispatch_get_main_queue(), delayBlock);
}

+ (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length {
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++) {
        [mutableString appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:mutableString];
}

#pragma mark - 字符串转换为日期时间对象
+ (NSDate *)dateFromString:(NSString *)str {
    // 创建一个时间格式化对象
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    
    // 设定时间的格式
    [datef setDateFormat:@"yyyy-MM-dd"];
    
    // 将字符串转换为时间对象
    NSDate *tempDate = [datef dateFromString:str];
    return tempDate;
}

#pragma mark - 将提供的字符串类型的日期转换成特定的格式返回
+ (NSString *)intTOTime:(NSString *)currentInt {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentInt intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return  confromTimespStr;
}

#pragma mark - 获取系统当前的时间戳
+ (NSString *)getUNIXTimeInterval {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

#pragma mark - 设置控制器在导航控制器上的标题
+ (void)naviTitle:(UINavigationItem *)item withString:(NSString *)str {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = str;
    label.adjustsFontSizeToFitWidth = YES;
    label.font =  [UIFont fontWithName:@"Arial" size:20.0f];
    item.titleView = label;
}

#pragma mark - 设置个股详情页导航栏的标题
+ (void)naviTitle:(UINavigationItem *)item withUpString:(NSString *)UpStr withDownString:(NSString *)downStr {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.textColor = [UIColor whiteColor];
    upLabel.font = [UIFont systemFontOfSize:20.0f];
    upLabel.text = UpStr;
    [titleView addSubview:upLabel];
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 150, 14)];
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = [UIColor whiteColor];
    downLabel.font = [UIFont systemFontOfSize:17.0f];
    downLabel.text = downStr;
    [titleView addSubview:downLabel];
    item.titleView = titleView;
}


#pragma mark - 根据字符串的内容，字体大小以及宽度来计算其高度
+ (CGFloat)calculateStringHeight:(NSString *)text withFont:(UIFont *)font withMaxWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.height;
}

#pragma mark - 判断当前网络状态
+ (int)isWiFiOK {
    Reachability *rrr = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    int returnNum;
    switch ([rrr currentReachabilityStatus]) {
        case NotReachable:     // 没有网络连接
            returnNum = 0;
            break;
        case ReachableViaWWAN: // 使用3G网络
            returnNum = 1;
            break;
        case ReachableViaWiFi: // 使用WiFi网络
            returnNum = 2;
            break;
    }
    return returnNum;
}

#pragma mark - 时间对象转换为时间字段信息
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    
    // 获取代表公历的Calendar对象
    NSCalendar *calenar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // 定义一个时间段的旗标，指定将会获取指定的年，月，日，时，分，秒的信息
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    
    // 获取不同时间字段信息
    NSDateComponents *dateComp = [calenar components:unitFlags fromDate:date];
    return dateComp;
}

#pragma mark - 根据键值获取数据
+ (NSObject *)getUserDefaults:(NSString *)name {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:name];
}

#pragma mark - 根据键值存储数据
+ (void)setUserDefaults:(NSObject *)defaults forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:defaults forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - MD5 16位加密
+ (NSString *)md5HexDigest:(NSString *)password {
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

#pragma mark - 手机号码的有效性判断 最新版本
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES) || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)  || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 获取一个随机整数，范围在[from,to]，包括from，包括to
+ (NSInteger)getRandomNumber:(NSInteger)from To:(NSInteger)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - 将HTML5字符串格式转换成HTML5格式
+ (NSAttributedString *)getStringFromHTML5String:(NSString *)htmlString {
    NSMutableAttributedString *htmlStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    [htmlStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(0, htmlStr.length)];
    
    return htmlStr;
}

#pragma mark - 调节html中的图片大小
+ (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent {
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:35%}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    [strContent appendString:@"<title>webview</title>"];
    
    return strContent;
}


+ (NSString *)currentDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end

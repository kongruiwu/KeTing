//
//  KTFactory.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "ConfigHeader.h"
#import "PlayTextButton.h"
@interface KTFactory : NSObject
+ (UITableView *)creatTabviewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

+ (UILabel *)creatLabelWithText:(NSString *)title fontValue:(float)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

+ (void)setLabel:(UILabel *)label BorderColor:(UIColor *)color with:(CGFloat)withValue cornerRadius:(CGFloat)radiusValue;

+ (UIButton *)creatButtonWithTitle:(NSString *)title backGroundColor:(UIColor *)groundColor textColor:(UIColor *)textColor textSize:(float)fontValue;

+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage;

+ (UIImageView *)creatImageViewWithImage:(NSString *)imageName;

+ (UIImageView *)creatArrowImage;

+ (UIView *)creatLineView;

+ (UIView *)creatViewWithColor:(UIColor *)color;

+ (NSAttributedString *)setFreePriceString:(NSString *)price;

+ (NSString *)getTimeStingWithCurrentTime:(int)num andTotalTime:(int)totalSeconds;

+ (NSString *)getAudioSizeWithdataSize:(long)audioSize;

+ (UIButton *)creatPlayButtonWithImage:(NSString *)imageName title:(NSString *)title;

+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font;

+ (CGSize)getSize:(NSMutableAttributedString *)attributes maxSize:(CGSize)maxSize;

+ (NSString *)timestampSwitchTime:(NSInteger)timestamp;

/**
 format @"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 */

+ (NSString *)timestampWithDate:(NSNumber *)time andFormat:(NSString *)format;

+ (NSMutableAttributedString *)changeHtmlString:(NSString *)htmlstr withFont:(float)font;

+ (NSString *)encodeUrlString:(NSString *)string;

+ (UIImage *)getImageFromView:(UIView *)theView;

+ (UITextField *)creattextfildWithPlaceHloder:(NSString *)placeholer;

+ (UITextField *)creattextfildWithPlaceHloder:(NSString *)placeholer placeColor:(UIColor *)color;

+ (NSData *)dealWithAvatarImage:(UIImage *)avatarImage;
@end

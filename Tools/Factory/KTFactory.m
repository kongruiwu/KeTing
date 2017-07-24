//
//  KTFactory.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "KTFactory.h"

@implementation KTFactory

/**
 creat tabview
 */
+ (UITableView *)creatTabviewWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView * tabview = [[UITableView alloc]initWithFrame:frame style:style];
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator = NO;
    tabview.showsHorizontalScrollIndicator = NO;
    tabview.backgroundColor = [UIColor clearColor];
    return tabview;
}

/**
 creat Label
 */
+ (UILabel *)creatLabelWithText:(NSString *)title fontValue:(float)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment{
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = alignment;
    return label;
}
/**
  set label border 
 */
+ (void)setLabel:(UILabel *)label BorderColor:(UIColor *)color with:(CGFloat)withValue cornerRadius:(CGFloat)radiusValue{
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = withValue;
    label.layer.cornerRadius = radiusValue;
}
/**
 creat button
 */
+ (UIButton *)creatButtonWithTitle:(NSString *)title backGroundColor:(UIColor *)groundColor textColor:(UIColor *)textColor textSize:(float)fontValue{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:groundColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontValue];
    return button;
}
+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (selectImage != nil) {
        [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    return button;
}

/**
 creat imgView with img
 */
+ (UIImageView *)creatImageViewWithImage:(NSString *)imageName{
    UIImageView * imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:imageName];
    return imgView;
}

/**
 creat arrrowimage
 */
+ (UIImageView *)creatArrowImage{
    UIImageView * imgview = [[UIImageView alloc]init];
    imgview.image = [UIImage imageNamed:@"arrow"];
    return imgview;
}

/**
 creat line
 */
+ (UIView *)creatLineView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
    return view;
}

/**
 creat color view
 */
+ (UIView *)creatViewWithColor:(UIColor *)color{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = color;
    return view;
}

+ (NSAttributedString *)setFreePriceString:(NSString *)price{
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:price];
    [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_lightGray range:NSMakeRange(0, price.length)];
    [attstr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, price.length)];
    
    return attstr;
}
/**
 根据总时间返回当前时间及格式 
 */
+ (NSString *)getTimeStingWithCurrentTime:(int)num andTotalTime:(int)totalSeconds{
    int seconds = num % 60;
    int minutes = (num / 60) % 60;
    int hours = num / 3600;
    int totalHour = totalSeconds / 3600;
    if (totalHour>0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
}

/**
 获取音频大小
 */
+ (NSString *)getAudioSizeWithdataSize:(long)audioSize{
    int Gnum = (int)audioSize/1024/1024/1024;
    float Mnum = (float)(audioSize -  Gnum * 1024 * 1024 * 1024)/1024/1024;
    NSString * size ;
    if (Gnum>0) {
        size = [NSString stringWithFormat:@"%dG%.2fM",Gnum,Mnum];
    }else{
        size = [NSString stringWithFormat:@"%.2fM",Mnum];
    }
    return size;
}
/**
    creat AudioPlayerViewController bottom Button
 */
+ (UIButton *)creatPlayButtonWithImage:(NSString *)imageName title:(NSString *)title{
    PlayTextButton * button = [PlayTextButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:KTColor_darkGray forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font750(24)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;

    return button;
}
/**
 get text size
 */
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font{
    CGSize sizeFirst = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    return sizeFirst;
}
+ (CGSize)getSize:(NSMutableAttributedString *)attributes maxSize:(CGSize)maxSize{
    CGSize attSize = [attributes boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return attSize;
}

/**
 将时间戳转化为时间
 */
+(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"MM月dd日"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+ (NSString *)getUpdateTimeStringWithEditTime:(NSNumber *)edittime{
    long timevalue = time(NULL);
    long edit = [edittime longLongValue];
    long time = timevalue - edit;
    NSString * timeString;
    if (60 * 60 >time >0) {
        timeString = [NSString stringWithFormat:@"%d分钟前",(int)time/60];
    }else if(60 * 60 * 24 >time){
        timeString = [NSString stringWithFormat:@"%d小时前",(int)time/60/60];
    }else{
        timeString = [self timestampSwitchTime:[edittime integerValue]];
    }
    return timeString;
}



+ (NSString *)timestampWithDate:(NSNumber *)time andFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [dateFormatter setTimeZone:timeZone];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
    NSString * dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
+ (NSMutableAttributedString *)changeHtmlString:(NSString *)htmlstr withFont:(float)font{
    NSString * str = [htmlstr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:
                                                   [str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:KTColor_darkGray
                             range:NSMakeRange(0, attributedString.length)];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 2;  // 段落高度
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}
+ (NSString *)encodeUrlString:(NSString *)string {
    return CFBridgingRelease(
                             CFURLCreateStringByAddingPercentEscapes(
                                                                     kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)string,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8)
                             );
}
/**将view的内容转化为image*/
+ (UIImage *)getImageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**登陆界面 textfield*/
+ (UITextField *)creattextfildWithPlaceHloder:(NSString *)placeholer{
    UITextField * textf = [[UITextField alloc]init];
    textf.font = [UIFont systemFontOfSize:font750(30)];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:placeholer];
    [attstr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x6c6a77) range:NSMakeRange(0, placeholer.length)];
    textf.attributedPlaceholder = attstr;
    textf.textColor = [UIColor whiteColor];
    textf.textAlignment = NSTextAlignmentLeft;
    return textf;
}
+ (UITextField *)creattextfildWithPlaceHloder:(NSString *)placeholer placeColor:(UIColor *)color{
    UITextField * textf = [[UITextField alloc]init];
    textf.font = [UIFont systemFontOfSize:font750(30)];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:placeholer];
    [attstr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, placeholer.length)];
    textf.attributedPlaceholder = attstr;
    textf.textColor = KTColor_MainBlack;
    textf.textAlignment = NSTextAlignmentLeft;
    return textf;
}

/**上传图片压缩尺寸*/
+ (NSData *)dealWithAvatarImage:(UIImage *)avatarImage{
    CGSize avatarSize = avatarImage.size;
    CGSize newSize = CGSizeMake(640, 640);
    //尺寸压缩
    if (avatarSize.width <= newSize.width && avatarSize.height <= newSize.height) {
        newSize = avatarSize;
    }
    else if (avatarSize.width > newSize.width && avatarSize.height > newSize.height) {
        CGFloat tempLength = avatarSize.width > avatarSize.height ?  avatarSize.width : avatarSize.height;
        CGFloat rate = tempLength / newSize.width;
        newSize.width = avatarSize.width / rate;
        newSize.height = avatarSize.height / rate;
    }
    else if (avatarSize.width > newSize.width) {
        newSize.height = avatarSize.height * newSize.width / avatarSize.width;
    }
    else {
        avatarSize.width = avatarSize.width * newSize.height / avatarSize.height;
    }
    UIImage *avatarNew = [self imageWithImage:avatarImage scaledToSize:newSize];
    NSData *data = UIImageJPEGRepresentation(avatarNew, 0.5);
    return data;
}
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

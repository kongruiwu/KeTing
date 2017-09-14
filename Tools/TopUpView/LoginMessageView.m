//
//  LoginMessageView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/9/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "LoginMessageView.h"

@implementation LoginMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    self.hidden = YES;
    
    self.groundView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.groundView.layer.cornerRadius = Anno750(10);
    
    self.titleLabel = [KTFactory creatLabelWithText:@"您尚未登录"
                                          fontValue:font750(34)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentCenter];
    self.topDesc = [KTFactory creatLabelWithText:@"未登录状态下充值会有以下限制："
                                       fontValue:font750(26)
                                       textColor:KTColor_darkGray
                                   textAlignment:NSTextAlignmentCenter];
    
    self.cannceBtn = [KTFactory creatButtonWithNormalImage:@"close" selectImage:nil];

    self.lineImg = [KTFactory creatImageViewWithImage:@""];
    self.lineImg.frame = CGRectMake(Anno750(60), Anno750(220), Anno750(400), Anno750(2));
    self.lineImg.image = [self drawLineByImageView:self.lineImg];
    
    self.contentDesc1 = [KTFactory creatLabelWithText:@"购买记录无法转移到其他帐号，"
                                            fontValue:font750(26)
                                            textColor:KTColor_darkGray
                                        textAlignment:NSTextAlignmentCenter];
    self.contentDesc2 = [KTFactory creatLabelWithText:@"仅限本设备使用"
                                            fontValue:font750(26)
                                            textColor:KTColor_darkGray
                                        textAlignment:NSTextAlignmentCenter];
    
    self.loginBtn = [KTFactory creatButtonWithTitle:@"先去登录"
                                    backGroundColor:KTColor_MainOrange
                                          textColor:[UIColor whiteColor]
                                           textSize:font750(28)];
    self.loginBtn.layer.cornerRadius = Anno750(5);
    
    self.deviceBtn = [KTFactory creatButtonWithTitle:@"仅在本设备使用"
                                     backGroundColor:[UIColor clearColor]
                                           textColor:KTColor_darkGray
                                            textSize:font750(26)];
    
    
    [self addSubview:self.groundView];
    [self.groundView addSubview:self.titleLabel];
    [self.groundView addSubview:self.cannceBtn];
    [self.groundView addSubview:self.topDesc];
    [self.groundView addSubview:self.lineImg];
    [self.groundView addSubview:self.contentDesc1];
    [self.groundView addSubview:self.contentDesc2];
    [self.groundView addSubview:self.loginBtn];
    [self.groundView addSubview:self.deviceBtn];
    
    
    [self.cannceBtn addTarget:self action:@selector(dismisView) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(320)));
        make.width.equalTo(@(Anno750(520)));
        make.height.equalTo(@(Anno750(600)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(84)));
        make.centerX.equalTo(@0);
    }];
    [self.cannceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-20)));
        make.top.equalTo(@(Anno750(20)));
    }];
    [self.topDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Anno750(40));
//        make.left.equalTo(@(Anno750(50)));
        make.centerX.equalTo(@0);
    }];
    
    [self.contentDesc1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topDesc.mas_bottom).offset(Anno750(56));
        make.left.equalTo(self.topDesc.mas_left);
//        make.centerX.equalTo(@0);
    }];
    [self.contentDesc2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentDesc1.mas_bottom).offset(Anno750(18));
        make.left.equalTo(self.contentDesc1.mas_left);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.contentDesc2.mas_bottom).offset(Anno750(60));
        make.width.equalTo(@(Anno750(400)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [self.deviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Anno750(32));
    }];
}
// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度  1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, UIColorFromRGB(0xbcbcbc).CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, UI_WIDTH - 10, 2.0);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();
}
- (void)dismiss{
    self.hidden = YES;
}

- (void)dismisView{
    self.hidden = YES;
}

- (void)show{
    self.hidden = NO;
}

@end

//
//  ShareView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShareModel.h"
@interface shareButton : UIButton

@end

@interface ShareView : UIView

//分享标题
@property (nonatomic, strong) NSString * shareTitle;
//分享描述
@property (nonatomic, strong) NSString * shareDesc;
//分享图片
@property (nonatomic, strong) NSString * imageUrl;
//分享目标
@property (nonatomic, strong) NSString * targeturl;
//图片
@property (nonatomic, strong) UIImage * image;


@property (nonatomic, strong) UIView * showView;
@property (nonatomic, strong) shareButton * wechatBtn;
@property (nonatomic, strong) shareButton * momentBtn;
@property (nonatomic, strong) shareButton * QQbtn;
@property (nonatomic, strong) UIView * grayView;
@property (nonatomic, strong) UIButton * disBtn;
@property (nonatomic, strong) UIButton * cannceBtn;


/**是否有导航栏， 有则需要计算动画高度*/
@property (nonatomic, assign) BOOL hasNav;

- (void)show;
- (void)disMiss;
- (instancetype)initWithFrame:(CGRect)frame hasNav:(BOOL)rec;
- (void)updateShareInfoWithTitle:(NSString *)title desc:(NSString *)desc contentUlr:(NSString *)url imageUrl:(NSString *)imageUrl;
- (void)updateWithShareModel:(ShareModel *)model;
- (void)setFristValue;
@end

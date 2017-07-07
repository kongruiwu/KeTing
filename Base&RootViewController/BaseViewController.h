//
//  BaseViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "NetWorkManager.h"
#import <MJRefresh.h>
#import "NullView.h"
@interface BaseViewController : UIViewController

@property (nonatomic, strong) MJRefreshNormalHeader * refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter * refreshFooter;
@property (nonatomic) SelectorBackType backType;
@property (nonatomic, strong) NullView * nullView;

- (void)setNavTitle:(NSString *)title color:(UIColor *)color;
- (void)drawBackButton;
- (void)drawBackButtonWithType:(BackImgType)type;
- (void)setNavAlphaWithWiteColor;
- (void)doBack;
- (void)setNavAlpha;
- (void)setNavUnAlpha;
- (void)RefreshSetting;
- (void)drawRightShareButton;
- (void)drawRightShareButtonBlackGround;
- (void)shareButtonClick;
- (void)showNullViewWithNullViewType:(NullType)type;
- (void)hiddenNullView;
//登陆使用
- (void)creatBackGroundImg;
@end

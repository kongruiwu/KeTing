//
//  ShareView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface shareButton : UIButton

@end

@interface ShareView : UIView



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
@end

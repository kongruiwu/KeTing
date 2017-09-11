//
//  LoginMessageView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/9/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface LoginMessageView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * topDesc;
@property (nonatomic, strong) UIImageView * lineImg;
@property (nonatomic, strong) UILabel * contentDesc1;
@property (nonatomic, strong) UILabel * contentDesc2;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * deviceBtn;
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UIButton * cannceBtn;


- (void)show;
- (void)dismiss;

@end

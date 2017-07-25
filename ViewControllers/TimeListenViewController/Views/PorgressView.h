//
//  PorgressView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
#import "ConfigHeader.h"
@interface PorgressView : UIView

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UAProgressView * progressView;

@property (nonatomic, strong) UIView * showView;
@property (nonatomic, strong) UIImageView * cannceImg;
@property (nonatomic, strong) UIButton * cannceBtn;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * desc1;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * desc2;


- (void)show;
- (void)disMiss;

@end

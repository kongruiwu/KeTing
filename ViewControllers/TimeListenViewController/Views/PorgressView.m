//
//  PorgressView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PorgressView.h"

@implementation PorgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self  creatUI];
    }
    return self;
}
- (void)creatUI{
    self.hidden = YES;
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    
    self.showView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    
    self.imageView = [KTFactory creatImageViewWithImage:@"listening_sift"];
    
    self.progressView = [[UAProgressView alloc]init];
    self.progressView.progress = 0;
    self.progressView.tintColor = KTColor_MainOrange;
    self.progressView.borderWidth = 0.0f;
    self.progressView.lineWidth = 3.0f;
    
    self.lineView = [KTFactory creatLineView];
    
    self.cannceImg = [KTFactory creatImageViewWithImage:@"time_close"];
    
    self.cannceBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    
    [self addSubview:self.showView];
    [self.showView addSubview:self.imageView];
    [self.imageView addSubview:self.progressView];
    [self.showView addSubview:self.lineView];
    [self.showView addSubview:self.cannceImg];
    [self addSubview:self.cannceBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@(UI_HEGIHT));
        make.height.equalTo(@(UI_HEGIHT - Anno750(270)));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(270)));
        make.height.equalTo(@(Anno750(270)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(200)));
        make.width.equalTo(@1);
    }];
    [self.cannceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.centerX.equalTo(@0);
    }];
    [self.cannceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(@(Anno750(200)));
        make.height.equalTo(@(Anno750(450)));
        make.centerX.equalTo(@0);
    }];

}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.showView.frame = CGRectMake(0, Anno750(270), UI_WIDTH, UI_HEGIHT - Anno750(270));
    }];
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH,UI_HEGIHT - Anno750(270));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        self.progressView.progress = 0;
    });
}


@end

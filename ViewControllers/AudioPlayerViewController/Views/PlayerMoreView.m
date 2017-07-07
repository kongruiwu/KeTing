//
//  PlayerMoreView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayerMoreView.h"

@implementation MoreButton

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage * img = self.imageView.image;
    self.imageView.frame = CGRectMake((self.bounds.size.width - img.size.width)/2, Anno750(50), img.size.width, img.size.height);
    self.titleLabel.frame = CGRectMake(0, Anno750(145), UI_WIDTH / 2, Anno750(30));
}

@end


@implementation PlayerMoreView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.showView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, Anno750(330));
    [self addSubview:self.showView];
    
    self.cannceBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    self.cannceBtn.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - Anno750(330));
    [self.cannceBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cannceBtn];
    
    self.closedButton = [self creatSubMoreButtonTitle:@"定时关闭" imageName:@"play_ close"];
    self.shareButton = [self creatSubMoreButtonTitle:@"分享" imageName:@"play_ share"];
    
    [self.showView addSubview:self.closedButton];
    [self.showView addSubview:self.shareButton];
    
    [self.closedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/2));
        make.height.equalTo(@(Anno750(220)));
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/2));
        make.height.equalTo(@(Anno750(220)));
    }];
    
    self.grayView = [KTFactory creatViewWithColor:Audio_progessWhite];
    [self.showView addSubview:self.grayView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(10)));
        make.top.equalTo(self.closedButton.mas_bottom);
    }];
    self.disbutton = [KTFactory creatButtonWithTitle:@"取消"
                                     backGroundColor:[UIColor clearColor]
                                           textColor:KTColor_lightGray
                                            textSize:font750(30)];
    [self.showView addSubview:self.disbutton];
    [self.disbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView.mas_bottom);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [self.disbutton addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    
}
- (MoreButton *)creatSubMoreButtonTitle:(NSString *)title imageName:(NSString *)imgName{
    MoreButton * btn = [MoreButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:KTColor_darkGray forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font750(26)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.showView.frame = CGRectMake(0, UI_HEGIHT - Anno750(330), UI_WIDTH,  Anno750(330));
    }];
    
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, Anno750(330));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

@end

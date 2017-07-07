//
//  VoiceDetailHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceDetailHeader.h"

@implementation VoiceDetailHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundImg = [KTFactory creatImageViewWithImage:@"default_h"];
    self.groundImg.userInteractionEnabled = YES;
    self.navView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    self.backBtn = [KTFactory creatButtonWithNormalImage:@"nav_back" selectImage:nil];
    self.shareBtn = [KTFactory creatButtonWithNormalImage:@"nav_share" selectImage:nil];
    self.shopCar = [KTFactory creatButtonWithNormalImage:@"nav_shopcar" selectImage:nil];
    self.grayView = [KTFactory creatViewWithColor:UIColorFromRGBA(0x000000, 0.3)];
    self.nameLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(32)
                                         textColor:[UIColor whiteColor]
                                     textAlignment:NSTextAlignmentLeft];
    self.shopCar.hidden = YES;
    [self addSubview:self.groundImg];
    [self.groundImg addSubview:self.navView];
    [self.navView addSubview:self.backBtn];
    [self.navView addSubview:self.shareBtn];
    [self.navView addSubview:self.shopCar];
    [self.groundImg addSubview:self.grayView];
    [self.groundImg addSubview:self.nameLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@44);
        make.top.equalTo(@20);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(30)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    [self.shopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-Anno750(15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(60)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(self.grayView.mas_centerY);
    }];
}

- (void)updateWithImage:(NSString *)imgurl title:(NSString *)title{
    [self.groundImg sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    self.nameLabel.text = title;
}
@end

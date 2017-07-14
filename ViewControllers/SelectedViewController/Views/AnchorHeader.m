//
//  AnchorHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AnchorHeader.h"

@implementation AnchorHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundImg = [KTFactory creatImageViewWithImage:@"anchorBg"];
    [self.groundImg setContentMode:UIViewContentModeScaleAspectFill];
    [self.groundImg setClipsToBounds:YES];
    
    self.groundImg.userInteractionEnabled = YES;
    self.userIcon = [KTFactory creatImageViewWithImage:@""];
    self.userIcon.layer.cornerRadius = Anno750(64);
    self.userIcon.layer.masksToBounds = YES;
    self.username = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(30)
                                        textColor:[UIColor whiteColor]
                                    textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(26)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    self.descLabel.numberOfLines = 2;
    self.showBtn = [KTFactory creatButtonWithNormalImage:@"voice_drop-down" selectImage:@"voice_pack up"];
    self.navView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    self.backBtn = [KTFactory creatButtonWithNormalImage:@"back_white" selectImage:nil];
    self.shareBtn = [KTFactory creatButtonWithNormalImage:@"listen_ share" selectImage:nil];
    self.shopCar = [KTFactory creatButtonWithNormalImage:@"listen__shopcar" selectImage:nil];
    
    self.countLabel = [KTFactory creatLabelWithText:@"0"
                                          fontValue:font750(20)
                                          textColor:[UIColor whiteColor]
                                      textAlignment:NSTextAlignmentCenter];
    self.countLabel.backgroundColor = KTColor_IconOrange;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = Anno750(15);
    self.countLabel.hidden = YES;
    
    [self addSubview:self.groundImg];
    [self addSubview:self.navView];
    [self.navView addSubview:self.backBtn];
    [self.navView addSubview:self.shareBtn];
    [self.navView addSubview:self.shopCar];
    [self addSubview:self.userIcon];
    [self addSubview:self.username];
    [self addSubview:self.descLabel];
    [self addSubview:self.showBtn];
    [self addSubview:self.countLabel];
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
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(150)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(128)));
        make.width.equalTo(@(Anno750(128)));
    }];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(10));
    }];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(Anno750(-20)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@(Anno750(40)));
        make.width.equalTo(@(Anno750(40)));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(74)));
        make.right.equalTo(self.showBtn.mas_left).offset(Anno750(-10));
        make.top.equalTo(self.username.mas_bottom).offset(Anno750(30));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopCar.mas_centerX).offset(Anno750(5));
        make.bottom.equalTo(self.shopCar.mas_centerY).offset(Anno750(-5));
        make.height.equalTo(@(Anno750(30)));
        make.width.equalTo(@(Anno750(30)));
    }];
}
- (void)updateWithAnchorModel:(AnchorModel *)model{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.face]];
    self.username.text = model.name;
    self.descLabel.text = model.summary;
    CGSize size = [KTFactory getSize:model.summary maxSize:CGSizeMake(99999, Anno750(30)) font:[UIFont systemFontOfSize:Anno750(26)]];
    if (size.width < Anno750(750 - 150)) {
        self.showBtn.hidden = YES;
        self.descLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        self.descLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (size.width > Anno750(750 - 160) * 2) {
        self.showBtn.hidden = NO;
    }else{
        self.showBtn.hidden = YES;
    }
}
- (void)updateShopCarCount:(NSString *)count{
    self.countLabel.text = count;
    self.countLabel.hidden = [count intValue]>0 ? NO:YES;
}
@end

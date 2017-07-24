//
//  RecommendView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.topImg = [KTFactory creatImageViewWithImage:@"defaultImage"];
    self.nameLabel = [KTFactory creatLabelWithText:@"权利的游戏"
                                         fontValue:font750(30)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@"独角兽与黑天鹅"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 2;
    self.priceLabel = [KTFactory creatLabelWithText:@"¥9.99/年"
                                          fontValue:font750(26)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    
    self.iconLabel = [KTFactory creatLabelWithText:@"限免"
                                         fontValue:font750(24)
                                         textColor:KTColor_IconOrange
                                     textAlignment:NSTextAlignmentCenter];
    
    self.coverBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [self addSubview:self.topImg];
    [self addSubview:self.iconLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.coverBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(Anno750(320)));
        make.height.equalTo(@(Anno750(320)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.topImg.mas_bottom).offset(Anno750(20));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(10));
        make.right.equalTo(@0);
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(10));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconLabel.mas_right);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(10));
    }];
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)updateWithHomeListenModel:(HomeListenModel *)model{
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.nameLabel.text = model.name;
    self.descLabel.text = model.summary;
    self.iconLabel.hidden = NO;
    if (model.isFree) {
        self.iconLabel.text = @"免费  ";
        [KTFactory setLabel:self.iconLabel BorderColor:[UIColor clearColor] with:0 cornerRadius:0];
    }else{
        //限免
        if ([model.promotionType intValue] == 2) {
            self.iconLabel.hidden = NO;
            self.iconLabel.text = @"限免  ";
            [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            self.priceLabel.attributedText = [KTFactory setFreePriceString:model.timePrice];
        }else{
            self.iconLabel.hidden = [model.promotionType integerValue] == 1 ? NO : YES;
            self.iconLabel.text = [model.promotionType integerValue] == 1 ? @"特惠  ":@"";
            if ([model.promotionType integerValue] == 1) {
                [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            }
            self.priceLabel.text = model.timePrice;
            self.priceLabel.textColor = KTColor_MainOrange;
        }
    }
    
}


@end

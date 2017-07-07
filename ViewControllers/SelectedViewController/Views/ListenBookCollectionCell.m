//
//  ListenBookCollectionCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenBookCollectionCell.h"

@implementation ListenBookCollectionCell


- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.topImage = [KTFactory creatImageViewWithImage:@"default_h"];
    self.nameLabel = [KTFactory creatLabelWithText:@"逻辑思维全集"
                                         fontValue:font750(26)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 2;
    self.iconLabel = [KTFactory creatLabelWithText:@"特惠"
                                         fontValue:font750(24)
                                         textColor:KTColor_IconOrange
                                     textAlignment:NSTextAlignmentCenter];
    [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
    self.priceLabel = [KTFactory creatLabelWithText:@"¥9.00"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.clickBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [self addSubview:self.topImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.clickBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(Anno750(190)));
        make.height.equalTo(@(Anno750(270)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(self.topImage.mas_bottom).offset(Anno750(15));
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImage.mas_left);
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(30)));
        make.bottom.equalTo(@(-Anno750(14)));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.iconLabel.hidden) {
            make.left.equalTo(self.topImage.mas_left);
        }else{
            make.left.equalTo(self.iconLabel.mas_right).offset(Anno750(10));
        }
        make.centerY.equalTo(self.iconLabel.mas_centerY);
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)updateWithListenModel:(HomeListenModel *)model{
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.nameLabel.text = model.name;
    if (model.isFree) {
        self.iconLabel.text = @"免费";
        [KTFactory setLabel:self.iconLabel BorderColor:[UIColor clearColor] with:0 cornerRadius:0];
    }else{
        //限免
        if ([model.promotionType intValue] == 2) {
            self.iconLabel.hidden = NO;
            self.iconLabel.text = @"限免";
            [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            self.priceLabel.attributedText = [KTFactory setFreePriceString:model.price];
        }else{
            self.iconLabel.hidden = YES;
            self.priceLabel.text = model.price;
            self.priceLabel.textColor = KTColor_MainOrange;
        }
    }
}
@end

//
//  ListenListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenListCell.h"

@implementation ListenListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{

    self.leftImg = [KTFactory creatImageViewWithImage:@"default_h"];
    self.nameLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 2;
    self.timeLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.saleStatus = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(24)
                                          textColor:KTColor_IconOrange
                                      textAlignment:NSTextAlignmentCenter];
    self.priceLabel = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.shopCar = [KTFactory creatButtonWithNormalImage:@"addshopcar" selectImage:@"listen_Added"];
    self.buybtn = [KTFactory creatButtonWithTitle:@"购买"
                                  backGroundColor:[UIColor clearColor]
                                        textColor:KTColor_MainOrange
                                         textSize:font750(24)];
    [self.buybtn setTitle:@"已购买" forState:UIControlStateSelected];
    self.buybtn.layer.borderColor = KTColor_MainOrange.CGColor;
    self.buybtn.layer.borderWidth = 1.0f;
    self.buybtn.layer.cornerRadius = 2.0f;
    self.bottomLine = [KTFactory creatLineView];
    
    [self.shopCar addTarget:self action:@selector(shopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buybtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.saleStatus];
    [self addSubview:self.priceLabel];
    [self addSubview:self.shopCar];
    [self addSubview:self.buybtn];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(190)));
        make.width.equalTo(@(Anno750(140)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(30)));
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(20));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(10));
    }];
    
    [self.saleStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.leftImg.mas_bottom);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saleStatus.mas_right);
        make.bottom.equalTo(self.leftImg.mas_bottom);
    }];
    [self.buybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(self.leftImg.mas_bottom);
        make.height.equalTo(@(Anno750(46)));
        make.width.equalTo(@(Anno750(100)));
    }];
    
    [self.shopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buybtn.mas_left).offset(Anno750(-40));
        make.centerY.equalTo(self.buybtn.mas_centerY);
        make.width.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(40)));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];

}

- (void)updateWithListenModel:(HomeListenModel *)model{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"default_h"]];
    self.nameLabel.text = model.name;
    self.descLabel.text = model.summary;
    NSString * audioLongStr = [NSString stringWithFormat:@"%@",model.audioLong];
    if ([audioLongStr containsString:@"分"]) {
        self.timeLabel.text = [NSString stringWithFormat:@"时长：%@",model.audioLong];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"时长：%@",[KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]]];
    }
    
    
    self.shopCar.hidden = model.Isbuy || model.isFree || [model.promotionType integerValue] == 2? YES: NO;
    self.buybtn.hidden = model.isFree || [model.promotionType integerValue] == 2? YES: NO;
    self.buybtn.selected = model.Isbuy;
    self.priceLabel.hidden =  model.isFree? YES:NO;
    if (model.isFree) {
        self.saleStatus.text = @"免费";
        [KTFactory setLabel:self.saleStatus BorderColor:[UIColor clearColor] with:0 cornerRadius:0];
    }else{
        //限免
        if ([model.promotionType intValue] == 2) {
            self.saleStatus.text = @"限免  ";
            [KTFactory setLabel:self.saleStatus BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            self.priceLabel.attributedText = [KTFactory setFreePriceString:model.timePrice];

        }else{
            self.priceLabel.text = model.timePrice;
            self.priceLabel.textColor = KTColor_MainOrange;
            self.saleStatus.text = [model.promotionType integerValue] == 1 ? @"特惠  " :@"";
            if ([model.promotionType integerValue] == 1) {
                [KTFactory setLabel:self.saleStatus BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            }
        }
    }
    self.shopCar.selected = model.iscart;
}
- (void)shopCarBtnClick:(UIButton *)btn{
    if (btn.selected) {
        if ([self.delegate respondsToSelector:@selector(checkShopCar)]) {
            [self.delegate checkShopCar];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(addToShopCar:)]) {
            [self.delegate addToShopCar:btn];
        }
    }
}
- (void)buyBtnClick:(UIButton *)btn{
    if (btn.selected) {
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"已购买过该书籍" duration:1.0f];
    }else{
        if ([self.delegate respondsToSelector:@selector(buyThisBook:)]) {
            [self.delegate buyThisBook:btn];
        }
    }
}

@end

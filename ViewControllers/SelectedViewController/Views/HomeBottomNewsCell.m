//
//  HomeBottomNewsCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeBottomNewsCell.h"

@implementation HomeBottomNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.backgroundColor = [UIColor whiteColor];
    self.leftImage = [KTFactory creatImageViewWithImage:@"default_h"];
    self.titleLabel = [KTFactory creatLabelWithText:@"「股市解密」洪校长的投资客课程"
                                          fontValue:font750(30)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 2;
    self.descLabel = [KTFactory creatLabelWithText:@"胡执政党跌停10个看，高耸装爱恋受热澎湖之咋呼低跌股价平临灭绝"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 5;
    self.iconLabel = [KTFactory creatLabelWithText:@"限免"
                                         fontValue:font750(24)
                                         textColor:KTColor_IconOrange
                                     textAlignment:NSTextAlignmentCenter];
    [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
    
    self.priceLabel = [KTFactory creatLabelWithText:@"¥0.99/季度"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    
    [self addSubview:self.leftImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.iconLabel];
    [self addSubview:self.priceLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(190)));
        make.height.equalTo(@(Anno750(235)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(Anno750(40));
        make.top.equalTo(self.leftImage.mas_top);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Anno750(10));
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(20));
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(30)));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.iconLabel.hidden) {
            make.left.equalTo(self.titleLabel.mas_left);
        }else{
            make.left.equalTo(self.iconLabel.mas_right).offset(Anno750(10));
        }
        make.centerY.equalTo(self.iconLabel.mas_centerY);
    }];
}
- (void)updateWithvoiceStockSecret:(HomeListenModel *)model{
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.titleLabel.text = model.name;
    self.descLabel.text = model.summary;
    self.priceLabel.hidden = model.isFree;
    if (model.isFree) {
        self.iconLabel.text = @"免费";
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

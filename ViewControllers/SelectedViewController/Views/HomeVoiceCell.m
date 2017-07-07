//
//  HomeVoiceCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeVoiceCell.h"

@implementation HomeVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.leftImage = [KTFactory creatImageViewWithImage:@"defaultImage"];
    self.titleLabel = [KTFactory creatLabelWithText:@"洪校长的投资客"
                                          fontValue:font750(30)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:font750(28)];
    self.descLabel = [KTFactory creatLabelWithText:@"胡执政党跌停10个看，高耸装爱恋受热澎湖之咋呼低跌股价平临灭绝"
                                         fontValue:font750(26)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 2;
    self.iconLabel = [KTFactory creatLabelWithText:@"限免"
                                         fontValue:font750(24)
                                         textColor:KTColor_IconOrange
                                     textAlignment:NSTextAlignmentCenter];
    [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
    
    self.priceLabel = [KTFactory creatLabelWithText:@"¥0.99/季度"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.topLine = [KTFactory creatLineView];
    
    self.updateTime = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(24)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentRight];
    self.updateTime.hidden = YES;
    
    self.sortImg = [KTFactory creatImageViewWithImage:@""];
    self.sortImg.hidden = YES;
    
    [self addSubview:self.leftImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.iconLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.topLine];
    [self addSubview:self.updateTime];
    [self.leftImage addSubview:self.sortImg];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(150)));
        make.height.equalTo(@(Anno750(136)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(Anno750(24));
        make.top.equalTo(self.leftImage.mas_top);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Anno750(7));
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.leftImage.mas_bottom);
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
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.updateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
    [self.sortImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
}
- (void)updateWithVoiceModel:(HomeListenModel *)model{
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
            self.iconLabel.text = @"限免";
            [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            self.priceLabel.attributedText = [KTFactory setFreePriceString:model.timePrice];
        }else{
            self.iconLabel.hidden = YES;
            self.priceLabel.text = model.price;
            self.priceLabel.textColor = KTColor_MainOrange;
        }
    }
    self.updateTime.text = [NSString stringWithFormat:@"更新于%@",[KTFactory timestampSwitchTime:model.editTime.integerValue]];
}
- (void)updateWithVoiceModel:(HomeListenModel *)model andSortNum:(NSInteger)num{
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
            self.iconLabel.text = @"限免";
            [KTFactory setLabel:self.iconLabel BorderColor:KTColor_IconOrange with:0.5 cornerRadius:0];
            self.priceLabel.attributedText = [KTFactory setFreePriceString:model.timePrice];
        }else{
            self.iconLabel.hidden = YES;
            self.priceLabel.text = model.price;
            self.priceLabel.textColor = KTColor_MainOrange;
        }
    }
    self.updateTime.text = [NSString stringWithFormat:@"更新于%@",[KTFactory timestampSwitchTime:model.editTime.integerValue]];
    switch (num) {
        case 0:
        {
            self.sortImg.hidden = NO;
            self.sortImg.image = [UIImage imageNamed:@"find_ one"];
        }
            break;
        case 1:
        {
            self.sortImg.hidden = NO;
            self.sortImg.image = [UIImage imageNamed:@"find_ two"];
        }
            break;
        case 2:
        {
            self.sortImg.hidden = NO;
            self.sortImg.image = [UIImage imageNamed:@"find_three"];
        }
            break;
        default:
            self.sortImg.hidden = YES;
            break;
    }
    
}
@end

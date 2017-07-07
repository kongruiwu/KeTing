//
//  ShopCarListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ShopCarListCell.h"

@implementation ShopCarListCell

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
    self.clearBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [self.clearBtn addTarget:self action:@selector(cleaderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selctButton = [KTFactory creatButtonWithNormalImage:@"icon_unselect" selectImage:@"icon_select"];
    self.leftImg = [KTFactory creatImageViewWithImage:@"defaultImage"];
    self.namelabel = [KTFactory creatLabelWithText:@"周小川：“一行三会”"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@"虎之争户政党跌停了，噶实打实大师答撒大啊实打实的"
                                         fontValue:font750(25)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [KTFactory creatLabelWithText:@"音频时长：22分22秒"
                                         fontValue:font750(25)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.priceLabel = [KTFactory creatLabelWithText:@"$199"
                                          fontValue:font750(28)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.lineView = [KTFactory creatLineView];
    
    [self addSubview:self.selctButton];
    [self addSubview:self.leftImg];
    [self addSubview:self.namelabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.clearBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(40)));
        make.centerY.equalTo(@0);
    }];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selctButton.mas_right).offset(Anno750(14));
        make.width.equalTo(@(Anno750(150)));
        make.height.equalTo(@(Anno750(140)));
        make.centerY.equalTo(@0);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(Anno750(78)));
    }];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.top.equalTo(self.leftImg.mas_top);
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel.mas_left);
        make.top.equalTo(self.namelabel.mas_bottom).offset(Anno750(4));
        make.right.equalTo(@(Anno750(-24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(4));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leftImg.mas_bottom).offset(Anno750(5));
        make.left.equalTo(self.timeLabel.mas_left);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithHomeListenModel:(HomeListenModel *)model{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    self.namelabel.text = model.name;
    self.descLabel.text = model.summary;
    self.priceLabel.text = model.timePrice;
    self.selctButton.selected = model.isSelect;
    self.timeLabel.text = [NSString stringWithFormat:@"音频时长：%@",model.audioLong];
}
- (void)cleaderBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectBook:)]) {
        [self.delegate selectBook:btn];
    }
}
@end

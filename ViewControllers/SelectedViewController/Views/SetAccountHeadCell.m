//
//  SetAccountHeadCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SetAccountHeadCell.h"

@implementation SetAccountHeadCell

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
    self.backgroundColor = KTColor_BackGround;
    self.whiteView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.whiteView.layer.cornerRadius = 3.0f;
    self.moneyLabel = [KTFactory creatLabelWithText:@"0.00牛币"
                                          fontValue:font750(48)
                                          textColor:KTColor_IconOrange
                                      textAlignment:NSTextAlignmentCenter];
    self.descLabel = [KTFactory creatLabelWithText:@"支付金额"
                                         fontValue:font750(28)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.whiteView];
    [self addSubview:self.descLabel];
    [self addSubview:self.moneyLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(65)));
        make.centerX.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(Anno750(15));
    }];
}
- (void)updateMoneyLabel:(NSString *)money{
    self.moneyLabel.text = [NSString stringWithFormat:@"%@牛币",money];
}
@end

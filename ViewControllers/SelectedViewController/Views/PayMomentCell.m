//
//  PayMomentCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PayMomentCell.h"

@implementation PayMomentCell

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
    self.leftImg = [KTFactory creatImageViewWithImage:@"close_balance"];
    self.nameLabel = [KTFactory creatLabelWithText:@"余额支付"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentCenter];
    self.descLabel = [KTFactory creatLabelWithText:@"剩余余额¥ 0.00"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    self.line = [KTFactory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.line];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(60)));
        make.centerX.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.leftImg.mas_bottom).offset(Anno750(20));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(10));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateUserBlance{
    NSString * moneyStr = [NSString stringWithFormat:@"剩余余额 ¥ %.2f",[[UserManager manager].balance floatValue]];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
    [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_IconOrange range:NSMakeRange(4, moneyStr.length - 4)];
    self.descLabel.attributedText = attstr;
}
@end

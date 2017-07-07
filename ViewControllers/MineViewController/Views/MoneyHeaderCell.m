//
//  MoneyHeaderCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MoneyHeaderCell.h"

@implementation MoneyHeaderCell

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
    
    UIImage * image = [UIImage imageNamed:@"my_ background"];
    UIEdgeInsets insets = UIEdgeInsetsMake(Anno750(130), Anno750(20), Anno750(20), Anno750(20));
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.groundImg = [[UIImageView alloc]initWithImage:image];
    
    self.moneyNumber = [KTFactory creatLabelWithText:@"¥25.50"
                                           fontValue:font750(50)
                                           textColor:KTColor_MoneyRed
                                       textAlignment:NSTextAlignmentCenter];
    self.moneyLabel = [KTFactory creatLabelWithText:@"钱包余额"
                                          fontValue:font750(30)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.groundImg];
    [self.groundImg addSubview:self.moneyNumber];
    [self.groundImg addSubview:self.moneyLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(45)));
        make.height.equalTo(@(Anno750(300)));
    }];
    [self.moneyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(130)));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.moneyNumber.mas_bottom).offset(Anno750(26));
    }];
}
- (void)updateWithMoneyNumber:(NSString *)money{
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",money]];
    [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(35)] range:NSMakeRange(0, 1)];
    self.moneyNumber.attributedText = attstr;
}

@end

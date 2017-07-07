//
//  TopUpListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopUpListCell.h"

@implementation TopUpListCell

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
    self.namelabel = [KTFactory creatLabelWithText:@"充值"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [KTFactory creatLabelWithText:@"2017-03-03 12:30:00"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.moneyLabel = [KTFactory creatLabelWithText:@"+6.00"
                                          fontValue:font750(30)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentRight];
    self.bottomLine = [KTFactory creatLineView];
    
    [self addSubview:self.namelabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
        make.right.equalTo(@(-Anno750(200)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.namelabel.mas_bottom).offset(Anno750(10));
        make.left.equalTo(@(Anno750(24)));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithModel:(TopUpModel *)model isTopUp:(BOOL)rec{
    self.namelabel.text = model.goodName;
    self.moneyLabel.textColor = rec? KTColor_MainOrange : [UIColor redColor];
    NSString * reduce = rec? @"+ ":@"- ";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",reduce,model.payAmount];
    self.timeLabel.text = [KTFactory timestampWithDate:model.payTime andFormat:@"YYYY-MM-dd HH:mm:ss"];
}
@end

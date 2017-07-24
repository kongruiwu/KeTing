//
//  MoneyDescCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MoneyDescCell.h"

@implementation MoneyDescCell

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
    self.topline = [KTFactory creatLineView];
    

    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"（1）购买后的商品，在苹果系统和其他系统均可使用\n（2）通过iOS内购平台充值后的余额仅限苹果系统使用，不与其他平台互通"];
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle02.lineHeightMultiple = 1.3;
    [attstr addAttribute:NSParagraphStyleAttributeName value:paraStyle02 range:NSMakeRange(0, attstr.length)];
    self.topLabel = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(26)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentLeft];
    self.topLabel.attributedText = attstr;
    self.topLabel.numberOfLines = 0;

    self.bottomLine = [KTFactory creatLineView];
    [self addSubview:self.topLabel];
    [self addSubview:self.topline];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.top.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
}
@end

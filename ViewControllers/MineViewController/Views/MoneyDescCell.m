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
    
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"1.苹果公司规定，虚拟商品必须使用苹果系统充值购买。\n2.充值如遇问题，请关注「可听kting」微信公众号，我们会为你解决。"];
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle02.lineHeightMultiple = 1.3;
    [attstr addAttribute:NSParagraphStyleAttributeName value:paraStyle02 range:NSMakeRange(0, attstr.length)];
    self.topLabel = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(24)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentLeft];
    self.topLabel.attributedText = attstr;
    self.topLabel.numberOfLines = 0;
    
    [self addSubview:self.topLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
}
@end

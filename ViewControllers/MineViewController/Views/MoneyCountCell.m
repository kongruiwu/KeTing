//
//  MoneyCountCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MoneyCountCell.h"

@implementation MoneyCountCell

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
    self.btnArray = [NSMutableArray new];
    for (int i = 0; i<6; i++) {
        UIButton * moneyBtn = [KTFactory creatButtonWithTitle:@"66元"
                                              backGroundColor:[UIColor clearColor]
                                                    textColor:KTColor_darkGray
                                                     textSize:font750(28)];
        moneyBtn.hidden = YES;
        moneyBtn.tag = 521 + i;
        [moneyBtn setBackgroundImage:[UIImage imageNamed:@"my_money"] forState:UIControlStateNormal];
        [moneyBtn setBackgroundImage:[UIImage imageNamed:@"my_money_pitch on"] forState:UIControlStateSelected];
        [self addSubview:moneyBtn];
        [moneyBtn addTarget:self action:@selector(choseMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:moneyBtn];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    float with = (UI_WIDTH - Anno750(48) - Anno750(210) * 3)/2;
    for (int i = 0; i<6; i++) {
        UIButton * moneyBtn = self.btnArray[i];
        [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24) + (Anno750(210)+with) * (i % 3)));
            make.top.equalTo(@(Anno750(40)+ Anno750(100) * (i/3)));
            make.width.equalTo(@(Anno750(210)));
            make.height.equalTo(@(Anno750(80)));
        }];
    }
}
- (void)choseMoneyBtn:(UIButton *)btn{
    for (int i = 0 ; i<self.btnArray.count; i++) {
        UIButton * moneyBtn = self.btnArray[i];
        moneyBtn.selected = NO;
    }
    btn.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPrice:)]) {
        [self.delegate sendPrice:btn.tag - 520];
    }
}
- (void)updateWithAmouts:(NSArray *)amount{
    
    for (int i = 0; i<amount.count; i++) {
        UIButton * btn = self.btnArray[i];
        btn.hidden = NO;
        [btn setTitle:[NSString stringWithFormat:@"%@",amount[i]] forState:UIControlStateNormal];
    }
}
@end

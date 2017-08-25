//
//  ShopCarFooter.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ShopCarFooter.h"

@implementation ShopCarFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectBtn = [KTFactory creatButtonWithNormalImage:@"icon_unselect" selectImage:@"icon_select"];
    self.moneyLabel = [KTFactory creatLabelWithText:@"合计：0.00牛币"
                                          fontValue:font750(28)
                                          textColor:KTColor_darkGray
                                      textAlignment:NSTextAlignmentLeft];
    self.buyBtn = [KTFactory creatButtonWithTitle:@"结算"
                                  backGroundColor:KTColor_MainOrangeAlpha
                                        textColor:[UIColor whiteColor]
                                         textSize:font750(30)];
    self.buyBtn.enabled = NO;
    self.buyBtn.layer.cornerRadius = 4.0f;
    self.lineView = [KTFactory creatLineView];
    
    
    [self addSubview:self.selectBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.buyBtn];
    [self addSubview:self.moneyLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(60)));
        make.centerY.equalTo(@0);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(Anno750(10));
        make.centerY.equalTo(@0);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(60)));
    }];
}

- (void)updateWithShopCarHnader:(ShopCarHander *)hander{
    self.moneyLabel.text = [NSString stringWithFormat:@"合计：%.2f牛币",hander.money];
    self.buyBtn.enabled = hander.count>0 ;
    if (self.buyBtn.enabled) {
        self.buyBtn.backgroundColor = KTColor_IconOrange;
        [self.buyBtn setTitle:[NSString stringWithFormat:@"结算 (%d)",hander.count] forState:UIControlStateNormal];
    }else{
        self.buyBtn.backgroundColor = KTColor_MainOrangeAlpha;
        [self.buyBtn setTitle:@"结算" forState:UIControlStateNormal];
    }
    self.selectBtn.selected = hander.isAllSelect;
}
- (void)updateDeleteStatusWithShopCarHander:(ShopCarHander *)hander{
    self.moneyLabel.text = @"全选";
    [self.buyBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.buyBtn.enabled = hander.deletCount>0 ;
    if (self.buyBtn.enabled) {
        self.buyBtn.backgroundColor = KTColor_IconOrange;
    }else{
        self.buyBtn.backgroundColor = KTColor_MainOrangeAlpha;
    }
    self.selectBtn.selected = hander.isAllDelete;
}
@end

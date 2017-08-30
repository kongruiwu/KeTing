//
//  SelectSectionHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SelectSectionHeader.h"

@implementation SelectSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftView = [KTFactory creatViewWithColor:KTColor_MainOrange];
    self.leftView.layer.cornerRadius = Anno750(3);
    self.titleLabel = [KTFactory creatLabelWithText:@"财经头条"
                                          fontValue:font750(34)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    self.iconLabel = [KTFactory creatLabelWithText:@"免费"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    [KTFactory setLabel:self.iconLabel BorderColor:KTColor_lightGray with:0.5 cornerRadius:0];
    
    self.checkAll = [KTFactory creatLabelWithText:@"查看全部"
                                        fontValue:font750(24)
                                        textColor:KTColor_lightGray
                                    textAlignment:NSTextAlignmentRight];
    self.checkButton = [KTFactory creatButtonWithTitle:@""
                                       backGroundColor:[UIColor clearColor]
                                             textColor:[UIColor clearColor]
                                              textSize:0];
    
    self.arrowImg = [KTFactory creatArrowImage];
    
    [self addSubview:self.leftView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconLabel];
    [self addSubview:self.checkAll];
    [self addSubview:self.arrowImg];
    [self addSubview:self.checkButton];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(6)));
        make.height.equalTo(@(Anno750(32)));
        make.centerY.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(Anno750(16));
        make.centerY.equalTo(@0);
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(32)));
        make.centerY.equalTo(@0);
        make.left.equalTo(self.titleLabel.mas_right).offset(Anno750(10));
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.checkAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.mas_left).offset(-Anno750(10));
        make.centerY.equalTo(@0);
    }];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
}

- (void)updateWithTitle:(NSString *)title andSection:(NSInteger)section{
    self.titleLabel.text = title;
    if (section == 0) {
        self.iconLabel.hidden = NO;
    }else{
        self.iconLabel.hidden = YES;
    }
    self.checkButton.tag = section + 1000;
}

@end

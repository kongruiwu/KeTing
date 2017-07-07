//
//  TopHeaderView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopHeaderView.h"

@implementation TopHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.cateBtn = [KTFactory creatButtonWithTitle:@"    分类"
                                   backGroundColor:[UIColor clearColor]
                                         textColor:KTColor_darkGray
                                          textSize:font750(30)];
    self.centerLine = [KTFactory creatLineView];
    self.downLoadBtn = [KTFactory creatButtonWithTitle:@"    下载"
                                       backGroundColor:[UIColor clearColor]
                                             textColor:KTColor_darkGray
                                              textSize:font750(30)];
    
    [self.cateBtn setImage:[UIImage imageNamed:@"finance_list"] forState:UIControlStateNormal];
    [self.downLoadBtn setImage:[UIImage imageNamed:@"finance_download"] forState:UIControlStateNormal];
    
    [self.downLoadBtn setImage:[UIImage imageNamed:@"finance_ close"] forState:UIControlStateSelected];
    [self.downLoadBtn setTitle:@"    取消下载" forState:UIControlStateSelected];

    
    [self addSubview:self.cateBtn];
    [self addSubview:self.centerLine];
    [self addSubview:self.downLoadBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(@(Anno750(20)));
        make.bottom.equalTo(@(-Anno750(20)));
        make.centerX.equalTo(@0);
    }];
    
    [self.cateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(self.centerLine.mas_left);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.left.equalTo(self.centerLine.mas_right);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}
- (void)updateWithImages:(NSArray *)images titles:(NSArray *)titles{
    [self.cateBtn setImage:[UIImage imageNamed:images[0]] forState:UIControlStateNormal];
    [self.cateBtn setTitle:titles[0] forState:UIControlStateNormal];
    
    [self.downLoadBtn setImage:[UIImage imageNamed:images[1]] forState:UIControlStateNormal];
    [self.downLoadBtn setTitle:titles[1] forState:UIControlStateNormal];
}
@end

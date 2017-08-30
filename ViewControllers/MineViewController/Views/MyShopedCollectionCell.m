//
//  MyShopedCollectionCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MyShopedCollectionCell.h"

@implementation MyShopedCollectionCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.imgView = [KTFactory creatImageViewWithImage:@"default_h"];
    self.nameLabel = [KTFactory creatLabelWithText:@"逻辑思维全集"
                                         fontValue:font750(28)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.imgView];
    [self addSubview:self.nameLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(Anno750(268)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(self.imgView.mas_bottom).offset(Anno750(20));
    }];
}
- (void)updateWithHomeListenModel:(HomeListenModel *)model{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"default_h"]];
    self.nameLabel.text = model.name;
}

@end

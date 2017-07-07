//
//  SubscribeSectionHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SubscribeSectionHeader.h"

@implementation ChangeButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIImage * img = self.imageView.image;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(img.size.width));
        make.height.equalTo(@(img.size.height));
    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(Anno750(66 - img.size.width)));
//        make.centerY.equalTo(self.imageView.mas_centerY);
//        make.width.equalTo(@(Anno750(100)));
//    }];
    
}

@end

@implementation SubscribeSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.leftview = [KTFactory creatViewWithColor:KTColor_MainOrange];
    self.nameLabel = [KTFactory creatLabelWithText:@"精品推荐"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.changeBtn = [ChangeButton buttonWithType:UIButtonTypeCustom];
    [self.changeBtn setTitle:@"换一换" forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:KTColor_lightGray forState:UIControlStateNormal];
    self.changeBtn.titleLabel.font = [UIFont systemFontOfSize:font750(26)];
    [self.changeBtn setImage:[UIImage imageNamed:@"subscription_ refresh"] forState:UIControlStateNormal];
    
    [self addSubview:self.leftview];
    [self addSubview:self.nameLabel];
    [self addSubview:self.changeBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(6)));
        make.height.equalTo(@(Anno750(32)));
        make.centerY.equalTo(@0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftview.mas_right).offset(Anno750(16));
        make.centerY.equalTo(@0);
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(0));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(Anno750(250)));
    }];
}
@end

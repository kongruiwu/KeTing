//
//  AnchorHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AnchorHeader.h"

@implementation AnchorHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundImg = [KTFactory creatImageViewWithImage:@"anchorBg"];
    
    self.groundImg.userInteractionEnabled = YES;
    self.userIcon = [KTFactory creatImageViewWithImage:@"default"];
    self.userIcon.layer.cornerRadius = Anno750(64);
    self.userIcon.layer.masksToBounds = YES;
    self.username = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(30)
                                        textColor:[UIColor whiteColor]
                                    textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(26)
                                         textColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00]
                                     textAlignment:NSTextAlignmentCenter];
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.groundImg];
    [self addSubview:self.userIcon];
    [self addSubview:self.username];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(150)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(128)));
        make.width.equalTo(@(Anno750(128)));
    }];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(10));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(74)));
        make.right.equalTo(@(-Anno750(74)));
        make.top.equalTo(self.username.mas_bottom).offset(Anno750(30));
    }];
    
}
- (void)updateWithAnchorModel:(AnchorModel *)model{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:[UIImage imageNamed:@"default"]];
    self.username.text = model.name;
    self.descLabel.text = model.summary;
}

@end

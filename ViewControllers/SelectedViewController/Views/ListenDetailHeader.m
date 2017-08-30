//
//  ListenDetailHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenDetailHeader.h"

@implementation ListenDetailHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    self.groundImg = [KTFactory creatImageViewWithImage:@"book_3"];
    self.bookImg = [KTFactory creatImageViewWithImage:@"default_h"];
    [self addSubview:self.groundImg];
    [self addSubview:self.bookImg];
    [self.bookImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(230)));
        make.height.equalTo(@(Anno750(330)));
    }];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImg.mas_left);
        make.top.equalTo(self.bookImg.mas_top);
    }];
}
- (void)updateWithImage:(NSString *)image{
    [self.bookImg sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"default_h"]];
}
@end

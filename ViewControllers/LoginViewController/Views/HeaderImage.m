//
//  HeaderImage.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HeaderImage.h"

@implementation HeaderImage

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.userIcon = [KTFactory creatImageViewWithImage:@"default_head"];
    [self addSubview:self.userIcon];
    self.userIcon.layer.masksToBounds = YES;
    
    self.photo = [[UIImageView alloc]init];
    self.photo.image = [UIImage imageNamed:@"camera"];
    [self addSubview:self.photo];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.clearBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.userIcon.layer.cornerRadius = self.frame.size.width/2;
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Anno750(35)));
        make.height.equalTo(@(Anno750(35)));
        make.right.equalTo(@(-Anno750(5)));
        make.bottom.equalTo(@(-Anno750(5)));
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
- (void)updateUserIcon{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserManager manager].info.ICON] placeholderImage:[UIImage imageNamed:@"default_head"]];
}
@end

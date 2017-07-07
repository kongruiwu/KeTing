//
//  RecommendListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "RecommendListCell.h"

@implementation RecommendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.FristView = [[RecommendView alloc]init];
    self.seconView = [[RecommendView alloc]init];
    self.FristView.coverBtn.tag = 1;
    self.seconView.coverBtn.tag = 2;
    [self.FristView.coverBtn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.seconView.coverBtn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.FristView];
    [self addSubview:self.seconView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.FristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(320)));
        make.bottom.equalTo(@(-Anno750(24)));
    }];
    [self.seconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.width.equalTo(@(Anno750(320)));
        make.top.equalTo(@(Anno750(24)));
        make.bottom.equalTo(@(-Anno750(24)));
    }];
}

- (void)updateWithFristModel:(HomeListenModel *)firstM secondModel:(id)secondM{
    [self.FristView updateWithHomeListenModel:firstM];
    if (secondM != nil) {
        [self.seconView updateWithHomeListenModel:secondM];
    }
    
}
- (void)coverBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(checkAudioDetail:)]) {
        [self.delegate checkAudioDetail:btn];
    }
}
@end

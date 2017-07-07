//
//  FindListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "FindListCell.h"

@implementation FindListCell

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
    self.leftImg = [KTFactory creatImageViewWithImage:@""];
    self.nameLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(30)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.nextIcon = [KTFactory creatArrowImage];
    self.bottomLine = [KTFactory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nextIcon];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(15));
        make.centerY.equalTo(@0);
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-24)));
        make.centerY.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)updateWithTitle:(NSString *)title imgName:(NSString *)imgName{
    self.nameLabel.text = title;
    self.leftImg.image = [UIImage imageNamed:imgName];
}
@end

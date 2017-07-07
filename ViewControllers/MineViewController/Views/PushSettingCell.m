//
//  PushSettingCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PushSettingCell.h"

@implementation PushSettingCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"推送消息设置"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.rightLabel = [KTFactory creatLabelWithText:@"已开启"
                                          fontValue:font750(24)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentRight];
    self.arrowIcon = [KTFactory creatArrowImage];
    self.descLabel = [KTFactory creatLabelWithText:@"如果您要关闭或开启可听的新消息通知，请在iPhone的“设置”-“通用”功能中，找到应用程序“可听”更改"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.arrowIcon];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowIcon.mas_left).offset(Anno750(-10));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(15));
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
    }];
}

@end

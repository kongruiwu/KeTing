//
//  SubscribeListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SubscribeListCell.h"

@implementation SubscribeListCell

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
    self.leftImg = [KTFactory creatImageViewWithImage:@"defaultImage"];
    self.nameLabel = [KTFactory creatLabelWithText:@"权利的游戏"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [KTFactory creatLabelWithText:@"十分钟前更新"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@"独角兽与灰天鹅"
                                         fontValue:font750(26)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.updateIcon = [KTFactory creatLabelWithText:@"1篇更新"
                                          fontValue:font750(26)
                                          textColor:KTColor_IconOrange
                                      textAlignment:NSTextAlignmentCenter];
    [KTFactory setLabel:self.updateIcon BorderColor:KTColor_IconOrange with:1.0f cornerRadius:2.0f];
    self.nextIcon = [KTFactory creatArrowImage];
    self.lineView = [KTFactory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.updateIcon];
    [self addSubview:self.nextIcon];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(120)));
        make.height.equalTo(@(Anno750(120)));
        make.centerY.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(20));
        make.top.equalTo(@(Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-Anno750(24)));
        make.left.equalTo(self.timeLabel.mas_left);
        make.right.equalTo(@(-Anno750(40)));
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    
    [self.updateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(self.nextIcon.mas_left).offset(Anno750(-20));
        make.width.equalTo(@(Anno750(120)));
        make.height.equalTo(@(Anno750(40)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
}

- (void)updateWithModel:(HomeListenModel *)model{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    self.nameLabel.text = model.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@更新",[KTFactory getUpdateTimeStringWithEditTime:model.editTime]];
    if (model.audio.count >0) {
        self.updateIcon.hidden = NO;
        self.updateIcon.text = [NSString stringWithFormat:@"%ld篇更新",model.audio.count];
    }else{
        self.updateIcon.hidden = YES;
    }
    self.descLabel.text = model.summary;
}
@end

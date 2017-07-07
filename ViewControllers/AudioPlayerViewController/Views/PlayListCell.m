//
//  PlayListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayListCell.h"

@implementation PlayListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 0;
    self.downLoadImg = [KTFactory creatImageViewWithImage:@"icon_selected"];
    self.dateLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.sizeLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.playStatusLabel = [KTFactory creatLabelWithText:@""
                                               fontValue:font750(24)
                                               textColor:KTColor_MainOrange
                                           textAlignment:NSTextAlignmentLeft];
    
    self.topLine = [KTFactory creatLineView];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.downLoadImg];
    [self addSubview:self.dateLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.playStatusLabel];
    [self addSubview:self.topLine];
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.downLoadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(15));
        make.width.equalTo(@(Anno750(26)));
        make.height.equalTo(@(Anno750(26)));
    }];
    CGSize size = [KTFactory getSize:self.dateLabel.text maxSize:CGSizeMake(UI_WIDTH, 99999) font:[UIFont systemFontOfSize:font750(24)]];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.downLoadImg.hidden) {
            make.left.equalTo(@(Anno750(24)));
        }else{
            make.left.equalTo(self.downLoadImg.mas_right).offset(Anno750(12));
        }
        make.centerY.equalTo(self.downLoadImg.mas_centerY);
        make.width.equalTo(@(size.width+Anno750(10)));
    }];
    size = [KTFactory getSize:self.timeLabel.text maxSize:CGSizeMake(UI_WIDTH, 99999) font:[UIFont systemFontOfSize:font750(24)]];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(Anno750(20));
        make.width.equalTo(@(size.width+Anno750(10)));
        make.centerY.equalTo(self.dateLabel.mas_centerY);
    }];
    size = [KTFactory getSize:self.sizeLabel.text maxSize:CGSizeMake(UI_WIDTH, 99999) font:[UIFont systemFontOfSize:font750(24)]];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@(size.width+Anno750(10)));
    }];
    [self.playStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sizeLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.sizeLabel.mas_centerY);
    }];
}
- (void)updateWithHomeTopModel:(HomeTopModel *)model
{
    if ([[AudioPlayer instance].currentAudio.onlyCode isEqualToString:model.onlyCode]) {
        self.nameLabel.textColor = KTColor_MainOrange;
    }else{
        self.nameLabel.textColor = KTColor_MainBlack;
    }
    self.nameLabel.text = model.audioName;
    self.dateLabel.text = [KTFactory timestampSwitchTime:model.addTime.integerValue];
    self.timeLabel.text = [NSString stringWithFormat:@"时长%@",[KTFactory getTimeStingWithCurrentTime:model.audioLong.intValue andTotalTime:model.audioLong.intValue]];
    self.sizeLabel.text = [KTFactory getAudioSizeWithdataSize:model.audioSize.longValue];
    self.playStatusLabel.hidden = YES;
}

@end

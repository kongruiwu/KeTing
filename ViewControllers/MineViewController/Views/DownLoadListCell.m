//
//  DownLoadListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadListCell.h"

@implementation DownLoadListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"权利的游戏"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.downLoadImg = [KTFactory creatImageViewWithImage:@"icon_selected"];
    self.downStatus = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(24)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentLeft];
    self.tagLabel = [KTFactory creatLabelWithText:@"已暂停，点击继续下载  3:47  财经  新闻"
                                        fontValue:font750(24)
                                        textColor:KTColor_lightGray
                                    textAlignment:NSTextAlignmentLeft];
    self.playStatus = [KTFactory creatLabelWithText:@"已播放3%"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.line = [KTFactory creatLineView];
    [self addSubview:self.downLoadImg];
    [self addSubview:self.downStatus];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.playStatus];
    [self addSubview:self.line];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
    [self.downLoadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.bottom.equalTo(@(-Anno750(20)));
    }];
    [self.downStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(self.downLoadImg.mas_centerY);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downStatus.mas_right);
        make.centerY.equalTo(self.downLoadImg.mas_centerY);
    }];
    [self.playStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.tagLabel.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)updateWithHistoryModel:(HomeTopModel *)model pausStatus:(BOOL)rec{
    self.downLoadImg.hidden = [model.downStatus intValue] == 2 ? NO :YES;
    if (!self.downLoadImg.hidden && !rec) {
        self.downStatus.text = @"    ";
    }
    if (rec) {
        self.downStatus.text = @"已暂停，点击继续下载";
    }
    self.nameLabel.text = model.audioName;
    NSString * time = [KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]];
    self.tagLabel.text = [NSString stringWithFormat:@"  %@  %@",time,model.tagString];
//    float value = [model.playLong floatValue]/[model.audioLong floatValue];
//    self.playStatus.text = [NSString stringWithFormat:@"已播：%d%%",(int)(value * 100)];
}

@end

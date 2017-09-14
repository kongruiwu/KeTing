//
//  TopListDownCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopListDownCell.h"

@implementation TopListDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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
    self.selctButton = [KTFactory creatButtonWithNormalImage:@"icon_unselect" selectImage:@"icon_select"];
    self.nameLabel = [KTFactory creatLabelWithText:@"洪校长的投资客"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 0;
    self.timeLabel = [KTFactory creatLabelWithText:@"3:47"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.playStutas = [KTFactory creatLabelWithText:@"已播100%"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    
    
    
    self.bottomLine = [KTFactory creatLineView];
    
    
    [self addSubview:self.selctButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.playStutas];
    [self addSubview:self.bottomLine];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.width.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(40)));
        make.centerY.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selctButton.mas_right).offset(Anno750(16));
        make.top.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(20));
    }];
    [self.playStutas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@(Anno750(150)));
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
}

- (void)updateWithHomeTopModel:(HomeTopModel *)model{
    
    self.selctButton.selected = model.isSelectDown;
    self.nameLabel.text = model.audioName;
    
    if ([[HistorySql sql] checkAudio:model.audioId]) {
        self.playStutas.hidden = NO;
        HomeTopModel * hisModel = [[HistorySql sql] getHometopModel:model.audioId];
        if (hisModel.playLong.integerValue>0) {
            self.playStutas.text = [NSString stringWithFormat:@"已播放%@%%",hisModel.playLong];
        }else{
            self.playStutas.text = @"";
        }
        self.nameLabel.textColor = KTColor_lightGray;
    }else{
        self.playStutas.hidden = YES;
        self.nameLabel.textColor = KTColor_MainBlack;
    }
    HomeTopModel * playModel = [AVQueenManager Manager].playList[[AVQueenManager Manager].playAudioIndex];
    if ([model.audioId isEqual:playModel.audioId]) {
        self.nameLabel.textColor = KTColor_MainOrange;
    }
    
    NSMutableString * time = [NSMutableString stringWithFormat:@"时长%@",[KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]]];
    [time appendFormat:@"  %@",[KTFactory getAudioSizeWithdataSize:[model.audioSize longValue]]];
    [time appendFormat:@"  %@",model.tagString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
}

-(void)updateVoiceDetailWithHomeTopModel:(HomeTopModel *)model{
    self.selctButton.selected = model.isSelectDown;
    self.nameLabel.text = model.audioName;
    self.playStutas.hidden = YES;
    
    if ([[HistorySql sql] checkAudio:model.audioId]) {
        self.nameLabel.textColor = KTColor_lightGray;
    }else{
        self.nameLabel.textColor = KTColor_MainBlack;
    }
    HomeTopModel * playModel = [AVQueenManager Manager].playList[[AVQueenManager Manager].playAudioIndex];
    if ([model.audioId isEqual:playModel.audioId]) {
        self.nameLabel.textColor = KTColor_MainOrange;
    }
    
    NSMutableString * time = [NSMutableString stringWithFormat:@"时长%@",[KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]]];
    [time appendFormat:@"  %@",[KTFactory getAudioSizeWithdataSize:[model.audioSize longValue]]];
    [time appendFormat:@"  %@",model.tagString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
}


@end

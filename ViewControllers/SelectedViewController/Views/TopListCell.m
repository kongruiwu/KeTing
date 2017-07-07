//
//  TopListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopListCell.h"

@implementation TopListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"洪校长的投资客"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 0;
    self.downLoadImg = [KTFactory creatImageViewWithImage:@"icon_selected"];
    self.timeLabel = [KTFactory creatLabelWithText:@"3:47"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.tagLabel = [KTFactory creatLabelWithText:@"财经"
                                        fontValue:font750(24)
                                        textColor:KTColor_lightGray
                                    textAlignment:NSTextAlignmentLeft];
    self.playStutas = [KTFactory creatLabelWithText:@"已播100%"
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.moreBtn = [KTFactory creatButtonWithNormalImage:@"icon_more" selectImage:@""];
    self.bottomLine = [KTFactory creatLineView];
    
    self.toolsbar = [KTFactory creatImageViewWithImage:@"top_inputbox"];
    self.downLoadBtn = [KTFactory creatButtonWithNormalImage:@"voice_download" selectImage:@""];
    self.textBtn = [KTFactory creatButtonWithNormalImage:@"voice_draft" selectImage:@""];
    self.likeBtn = [KTFactory creatButtonWithNormalImage:@"voice_like" selectImage:@""];
    self.shareBtn = [KTFactory creatButtonWithNormalImage:@"voice_ share" selectImage:@""];
    
    self.toolsbar.userInteractionEnabled = YES;
    [self.moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.downLoadBtn addTarget:self action:@selector(downLoadThisAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.textBtn addTarget:self action:@selector(checkThisAudioText) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self action:@selector(likeThisAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareThisAudio) forControlEvents:UIControlEventTouchUpInside];
    self.toolsbar.hidden = YES;
    
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.downLoadImg];
    [self addSubview:self.timeLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.playStutas];
    [self addSubview:self.moreBtn];
    [self addSubview:self.bottomLine];
    [self addSubview:self.toolsbar];
    [self.toolsbar addSubview:self.downLoadBtn];
    [self.toolsbar addSubview:self.textBtn];
    [self.toolsbar addSubview:self.likeBtn];
    [self.toolsbar addSubview:self.shareBtn];
    
}
- (void)moreButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
        [self.delegate moreBtnClick:self.moreBtn];
    }
}

- (void)downLoadThisAudio{
    if ([self.delegate respondsToSelector:@selector(downLoadAudio:)]) {
        [self.delegate downLoadAudio:self.downLoadBtn];
    }
}
- (void)checkThisAudioText{
    if ([self.delegate respondsToSelector:@selector(checkAudioText:)]) {
        [self.delegate checkAudioText:self.textBtn];
    }
}
- (void)likeThisAudio{
    if ([self.delegate respondsToSelector:@selector(likeAudioClick:)]) {
        [self.delegate likeAudioClick:self.likeBtn];
    }
}
- (void)shareThisAudio{
    if ([self.delegate respondsToSelector:@selector(shareBtnClick:)]) {
        [self.delegate shareBtnClick:self.shareBtn];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(80)));
    }];
    [self.downLoadImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(Anno750(26)));
        make.height.equalTo(@(Anno750(26)));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(20));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.downLoadImg.hidden) {
            make.left.equalTo(self.nameLabel.mas_left);
        }else{
            make.left.equalTo(self.downLoadImg.mas_right).offset(Anno750(20));
        }
        make.centerY.equalTo(self.downLoadImg.mas_centerY);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.playStutas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(Anno750(20));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.equalTo(@(Anno750(150)));
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    UIImage * img = [UIImage imageNamed:@"top_inputbox"];
    [self.toolsbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(self.moreBtn.mas_left).offset(-Anno750(24));
    }];
    float with = (img.size.width - Anno750(10))/4;
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(with));
        make.height.equalTo(@(img.size.height));
    }];
    [self.textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downLoadBtn.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(with));
        make.height.equalTo(@(img.size.height));
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textBtn.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(with));
        make.height.equalTo(@(img.size.height));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeBtn.mas_right);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(with));
        make.height.equalTo(@(img.size.height));
    }];
}




- (void)updateWithHomeTopModel:(HomeTopModel *)model{
    
    self.nameLabel.text = model.audioName;
    self.timeLabel.text = [KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]];
    int playTime = (int)([model.playTime floatValue] / [model.audioLong floatValue] * 100);
    if (playTime == 0) {
        self.playStutas.hidden = YES;
    }else{
        self.playStutas.hidden = NO;
        self.playStutas.text = [NSString stringWithFormat:@"已播放%d%%",playTime];
    }
    NSMutableString * tagString = [[NSMutableString alloc]init];
    for (int i = 0; i<model.tagModels.count; i++) {
        if (i == 0) {
            [tagString appendString:[NSString stringWithFormat:@"%@",model.tagModels[i].tagName]];
        }else{
            [tagString appendString:[NSString stringWithFormat:@"    %@",model.tagModels[i].tagName]];
        }
    }
    self.tagLabel.text = tagString;
    self.toolsbar.hidden = !model.showTools;
}
- (void)updateWithTagAudioModel:(TagAudioModel *)model{
    self.nameLabel.text = model.audioName;
    self.timeLabel.text = [KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]];
    self.playStutas.hidden = YES;
    NSArray * tags = [model.tagName componentsSeparatedByString:@","];
    NSMutableString * tagString = [[NSMutableString alloc]init];
    for (int i = 0; i<tags.count; i++) {
        if (i == 0) {
            [tagString appendString:tags[i]];
        }else{
            [tagString appendString:[NSString stringWithFormat:@"    %@",tags[i]]];
        }
    }
    self.tagLabel.text = tagString;
}
@end

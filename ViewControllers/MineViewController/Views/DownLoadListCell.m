//
//  DownLoadListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadListCell.h"
#import "HistorySql.h"
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
    self.selectButton = [KTFactory creatButtonWithNormalImage:@"icon_unselect" selectImage:@"icon_select"];
    self.selectButton.frame = CGRectMake(Anno750(24), (Anno750(120) - Anno750(40))/2, Anno750(40), Anno750(40));
    self.moveView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.moveView.frame = CGRectMake(Anno750(64), 0, UI_WIDTH - Anno750(48), Anno750(120));
    
    
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
    self.playStatus = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(24)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    self.line = [KTFactory creatLineView];
    [self addSubview:self.selectButton];
    [self addSubview:self.moveView];
    [self.moveView addSubview:self.downLoadImg];
    [self.moveView addSubview:self.downStatus];
    [self.moveView addSubview:self.nameLabel];
    [self.moveView addSubview:self.tagLabel];
    [self.moveView addSubview:self.playStatus];
    [self addSubview:self.line];
    
//    self.moreBtn = [KTFactory creatButtonWithNormalImage:@"icon_more" selectImage:@""];
//    self.toolsbar = [KTFactory creatImageViewWithImage:@"top_inputbox"];
//    self.downLoadBtn = [KTFactory creatButtonWithNormalImage:@"voice_download" selectImage:@""];
//    self.textBtn = [KTFactory creatButtonWithNormalImage:@"voice_draft" selectImage:@""];
//    self.likeBtn = [KTFactory creatButtonWithNormalImage:@"voice_like" selectImage:@"listen_liked"];
//    self.shareBtn = [KTFactory creatButtonWithNormalImage:@"voice_ share" selectImage:@""];
//    
//    self.toolsbar.userInteractionEnabled = YES;
//    [self.moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.downLoadBtn addTarget:self action:@selector(downLoadThisAudio) forControlEvents:UIControlEventTouchUpInside];
//    [self.textBtn addTarget:self action:@selector(checkThisAudioText) forControlEvents:UIControlEventTouchUpInside];
//    [self.likeBtn addTarget:self action:@selector(likeThisAudio) forControlEvents:UIControlEventTouchUpInside];
//    [self.shareBtn addTarget:self action:@selector(shareThisAudio) forControlEvents:UIControlEventTouchUpInside];
//    self.toolsbar.hidden = YES;
//    
//    [self addSubview:self.moreBtn];
//    [self addSubview:self.textBtn];
//    [self addSubview:self.toolsbar];
//    [self.toolsbar addSubview:self.downLoadBtn];
//    [self.toolsbar addSubview:self.likeBtn];
//    [self.toolsbar addSubview:self.shareBtn];
    
}
//- (void)moreButtonClick{
//    
//    if ([self.delegate respondsToSelector:@selector(moreBtnClick:)]) {
//        [self.delegate moreBtnClick:self.moreBtn];
//    }
//}
//
//- (void)downLoadThisAudio{
//    if ([self.delegate respondsToSelector:@selector(downLoadAudio:)]) {
//        [self.delegate downLoadAudio:self.downLoadBtn];
//    }
//}
//- (void)checkThisAudioText{
//    if ([self.delegate respondsToSelector:@selector(checkAudioText:)]) {
//        [self.delegate checkAudioText:self.textBtn];
//    }
//}
//- (void)likeThisAudio{
//    if ([self.delegate respondsToSelector:@selector(likeAudioClick:)]) {
//        [self.delegate likeAudioClick:self.likeBtn];
//    }
//}
//- (void)shareThisAudio{
//    if ([self.delegate respondsToSelector:@selector(shareBtnClick:)]) {
//        [self.delegate shareBtnClick:self.shareBtn];
//    }
//}


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
    
    
    
//    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.bottom.equalTo(@0);
//        make.right.equalTo(@(-Anno750(24)));
//    }];
//    [self.textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.moreBtn.mas_left).offset(Anno750(-25));
//        make.centerY.equalTo(@0);
//    }];
//    UIImage * img = [UIImage imageNamed:@"top_inputbox"];
//    [self.toolsbar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(@0);
//        make.right.equalTo(self.moreBtn.mas_left).offset(-Anno750(24));
//    }];
//    float with = (img.size.width - Anno750(10))/3;
//    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.centerY.equalTo(@0);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@(img.size.height));
//    }];
//    
//    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.downLoadBtn.mas_right);
//        make.centerY.equalTo(@0);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@(img.size.height));
//    }];
//    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.likeBtn.mas_right);
//        make.centerY.equalTo(@0);
//        make.width.equalTo(@(with));
//        make.height.equalTo(@(img.size.height));
//    }];

    
}
- (void)updateWithHistoryModel:(HomeTopModel *)model pausStatus:(BOOL)rec isDown:(BOOL)isDown{

    self.downLoadImg.hidden = !isDown;
    if (!self.downLoadImg.hidden && !rec) {
        self.downStatus.text = @"    ";
    }
    if (rec) {
        self.downStatus.text = @"已暂停";
    }
    self.nameLabel.text = model.audioName;
    NSString * time = [KTFactory getTimeStingWithCurrentTime:[model.audioLong intValue] andTotalTime:[model.audioLong intValue]];
    self.selectButton.selected = model.isSelectDown;
    NSString * size = [KTFactory getAudioSizeWithdataSize:[model.audioSize longValue]];
    self.tagLabel.text = [NSString stringWithFormat:@"  %@  %@  %@",time,size,model.tagString];
    self.playStatus.hidden = YES;
    

    
//    self.toolsbar.hidden = !model.showTools;
    
}
- (void)showSelectBotton:(BOOL)rec{
    if (rec) {
        self.selectButton.frame = CGRectMake(Anno750(24), (Anno750(120) - Anno750(40))/2, Anno750(40), Anno750(40));
        self.moveView.frame = CGRectMake(Anno750(64), 0, UI_WIDTH - Anno750(48), Anno750(120));
    }else{
        self.selectButton.frame = CGRectMake(0, (Anno750(120) - Anno750(40))/2,0, Anno750(40));
        self.moveView.frame = CGRectMake(0, 0, UI_WIDTH - Anno750(48), Anno750(120));
    }
}
@end

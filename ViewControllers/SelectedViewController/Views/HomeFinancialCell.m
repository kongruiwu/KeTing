//
//  HomeFinancialCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeFinancialCell.h"

@implementation HomeFinancialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.backgroundColor = [UIColor whiteColor];
    
    self.topButtons = [NSMutableArray new];
    
    self.topLine = [KTFactory creatLineView];
    self.playButton = [KTFactory creatButtonWithNormalImage:@"home_play" selectImage:@""];
    
    for (int i = 0; i<10; i++) {
        GifPlayButton * button = [GifPlayButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:KTColor_lightGray forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:font750(26)];
        button.hidden = YES;
        button.tag = i;
        [button setImage:[UIImage imageNamed:@"dotwhite"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        [button setTitleColor:KTColor_MainOrange forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button addTarget:self action:@selector(playThisAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.topButtons addObject:button];
        [self addSubview:button];
    }
    [self.playButton addTarget:self action:@selector(playThisList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    [self addSubview:self.topLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i<self.topButtons.count; i++) {
        UIButton * button = self.topButtons[i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@((Anno750(25) + Anno750(50) * i)));
            make.left.equalTo(@(Anno750(24)));
            make.height.equalTo(@(Anno750(50)));
            make.width.equalTo(@(Anno750(520)));
        }];
    }
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-50)));
        make.height.equalTo(@(Anno750(124)));
        make.width.equalTo(@(Anno750(124)));
        make.centerY.equalTo(@0);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithHomeTopModels:(NSArray *)models{
    for (int i = 0; i< models.count; i++) {
        HomeTopModel * model = models[i];
        UIButton * button = self.topButtons[i];
        button.hidden = NO;
        HomeTopModel * playmodel = [AVQueenManager Manager].playList[[AVQueenManager Manager].playAudioIndex];
        if ([model.audioId isEqual:playmodel.audioId]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [button setTitle:[NSString stringWithFormat:@"  %@",model.audioName] forState:UIControlStateNormal];
    }
}
- (void)playThisAudio:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(PlayAudioAtIndex:)]) {
        [self.delegate PlayAudioAtIndex:btn.tag];
    }
}
- (void)playThisList{
    if ([self.delegate respondsToSelector:@selector(PlayTopList)]) {
        [self.delegate PlayTopList];
    }
}
@end

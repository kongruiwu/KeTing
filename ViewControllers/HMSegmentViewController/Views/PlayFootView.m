//
//  PlayFootView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayFootView.h"
#import "HistorySql.h"
#import "AVQueenManager.h"
@implementation PlayFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.leftImg = [KTFactory creatImageViewWithImage:@"register_logo"];
    self.leftImg.layer.masksToBounds = YES;
    self.leftImg.layer.cornerRadius = Anno750(35);
    self.nameLabel = [KTFactory creatLabelWithText:@"可听"
                                         fontValue:font750(24)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 2;
    self.line = [KTFactory creatLineView];
    self.nextBtn = [KTFactory creatButtonWithNormalImage:@"home_next" selectImage:@""];
    self.playBtn = [KTFactory creatButtonWithNormalImage:@"bottomplay" selectImage:@"play_stop"];
    self.listBtn = [KTFactory creatButtonWithNormalImage:@"home_ ist" selectImage:@""];
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.trackTintColor = [UIColor whiteColor];
    self.progressView.progressTintColor = KTColor_MainOrange;
    self.clearButton = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(playNextAudio) forControlEvents:UIControlEventTouchUpInside];
    
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self audioImageAnimtion];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nextBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.listBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.line];
    [self addSubview:self.clearButton];
    
}
- (void)tick{
    self.progressView.progress = ([AVQueenManager Manager].bottomProgress)/100;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(@0);
    }];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(70)));
        make.width.equalTo(@(Anno750(70)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(360)));
    }];
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(55)));
        make.width.equalTo(@(Anno750(55)));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.listBtn.mas_left).offset(-Anno750(30));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(55)));
        make.width.equalTo(@(Anno750(55)));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextBtn.mas_left).offset(-Anno750(30));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(55)));
        make.width.equalTo(@(Anno750(55)));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(Anno750(6)));
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(self.nameLabel.mas_right);
    }];
}

/**添加动画*/
- (void)audioImageAnimtion{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 20.0f;
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.leftImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)changePlayStatus{
    
    if ([AVQueenManager Manager].endPlaying) {
        CALayer *layer = self.leftImg.layer;
        [layer removeAllAnimations];
        self.playBtn.selected = NO;
    }else{
        if ([AVQueenManager Manager].isPlaying) {
            self.playBtn.selected = YES;
            [self animationResume];
        }else{
            self.playBtn.selected = NO;
            [self animationStop];
        }
    }
    NSInteger index = [AVQueenManager Manager].playAudioIndex;
    HomeTopModel * model = [AVQueenManager Manager].playList[index];
    [self updateUI:model];
}


- (void)playBtnClick:(UIButton *)btn{
    if ([AVQueenManager Manager].endPlaying) {
        
        [[AVQueenManager Manager] playAudioAtIndex:[AVQueenManager Manager].playAudioIndex];
        
    }else{
        if ([AVQueenManager Manager].isPlaying) {
            [[AVQueenManager Manager] pause];
            [self animationStop];
        }else{
            [[AVQueenManager Manager] resume];
            [self animationResume];
        }
    }
    
}
- (void)playNextAudio{
    
    [[AVQueenManager Manager] playNextAudio];
    
}
- (void)updateUI:(HomeTopModel *)model1{
    HomeTopModel * model = model1;
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default"]];
    self.nameLabel.text = model.audioName;
    self.progressView.progress = [[AVQueenManager Manager] bottomProgress];
}

#pragma 暂停动画
- (void)animationStop
{
    CALayer *layer = self.leftImg.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}
#pragma 继续动画
- (void)animationResume
{
    CALayer *layer = self.leftImg.layer;
    if (![layer animationForKey:@"rotationAnimation"]) {
        [self audioImageAnimtion];
        return;
    }
    if (layer.speed == 1.0) {
        return;
    }
    CFTimeInterval pauseTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSince = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    layer.beginTime = timeSince;
}


@end

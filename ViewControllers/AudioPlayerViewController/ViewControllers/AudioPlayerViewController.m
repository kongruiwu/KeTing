//
//  AudioPlayerViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "PlayListView.h"
#import "PlayerMoreView.h"
#import "ShareView.h"
#import "PlayCloseListView.h"
#import "WKWebViewController.h"
#import "AudioDownLoader.h"
#import "LoginViewController.h"
#import "HistorySql.h"
@interface AudioPlayerViewController ()<AudioPlayerDelegate,AudioDownLoadDelegate,PlayListDelegate>
/**标签*/
@property (nonatomic, strong) UILabel * tagLabel;
/**封面图*/
@property (nonatomic, strong) UIImageView * audioImg;
@property (nonatomic, strong) UIImageView * audioPhoto;
/**播放进度*/
@property (nonatomic, strong) UILabel * currntNum;
/**后退*/
@property (nonatomic, strong) UIButton * backButton;
/**前进*/
@property (nonatomic, strong) UIButton * advanceButton;
/**上一曲*/
@property (nonatomic, strong) UIButton * upAudio;
/**下一曲*/
@property (nonatomic, strong) UIButton * nextAudio;
/**播放／暂停*/
@property (nonatomic, strong) UIButton * playBtn;
/**当前时间*/
@property (nonatomic, strong) UILabel * currentTime;
/**总时间*/
@property (nonatomic, strong) UILabel * totalTime;
/**进度条*/
@property (nonatomic, strong) UISlider * slider;
//列表
@property (nonatomic, strong) UIButton * listBtn;
//文稿
@property (nonatomic, strong) UIButton * textBtn;
//点赞
@property (nonatomic, strong) UIButton * likeBtn;
//下载
@property (nonatomic, strong) UIButton * downLoadBtn;
//更多
@property (nonatomic, strong) UIButton * moreBtn;

/**计时器*/
@property (nonatomic, strong) NSTimer * timer;
/**播放器动画*/
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;
/**播放器列表*/
@property (nonatomic, strong) PlayListView * playList;
/**更多列表*/
@property (nonatomic, strong) PlayerMoreView * MoreView;
/**分享*/
@property (nonatomic, strong) ShareView * shareView;
/**关机列表页*/
@property (nonatomic, strong) PlayCloseListView * closeList;
/**标题栏*/
@property (nonatomic, strong) UILabel * titleLabel;

/**获取详情后的model*/
@property (nonatomic, strong) HomeTopModel * newmodel;
@end

@implementation AudioPlayerViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AudioPlayer instance].delegate = self;
    [AudioDownLoader loader].delegate = self;
    [self setNavAlpha];
    [self getAudioDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AudioPlayer instance].delegate = nil;
    [AudioDownLoader loader].delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self audioImageAnimtion];
    [self playAudio];
}
- (void)creatUI{
    UIImage * image = [[UIImage imageNamed:@"voice_drop-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.backType = SelectorBackTypeDismiss;
    
    UIImageView * bgImgView = [KTFactory creatImageViewWithImage:@"play_background"];
    bgImgView.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
    bgImgView.userInteractionEnabled  = YES;
    [self.view addSubview:bgImgView];
    
    self.titleLabel = [KTFactory creatLabelWithText:@""
                                           fontValue:font750(34)
                                           textColor:[UIColor whiteColor]
                                       textAlignment:NSTextAlignmentCenter];
    self.titleLabel.numberOfLines = 0;
    
    self.tagLabel = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(24)
                                        textColor:KTColor_lightGray
                                    textAlignment:NSTextAlignmentCenter];
    self.audioImg = [KTFactory creatImageViewWithImage:@"player2"];
    self.audioPhoto = [KTFactory creatImageViewWithImage:@""];
    self.audioImg.layer.cornerRadius = Anno750(552/2);
    self.audioImg.layer.masksToBounds = YES;
    self.audioPhoto.layer.cornerRadius = Anno750(340/2);
    self.audioPhoto.layer.masksToBounds = YES;
    self.currntNum = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    self.playBtn = [KTFactory creatButtonWithNormalImage:@"play_play" selectImage:@"play-sto"];
    self.backButton = [KTFactory creatButtonWithNormalImage:@"play_ back" selectImage:@""];
    self.upAudio = [KTFactory creatButtonWithNormalImage:@"play_up" selectImage:@""];
    self.nextAudio = [KTFactory creatButtonWithNormalImage:@"play_next" selectImage:@""];
    self.advanceButton = [KTFactory creatButtonWithNormalImage:@"play_advance" selectImage:@""];
    self.currentTime = [KTFactory creatLabelWithText:@"0:09"
                                           fontValue:font750(24)
                                           textColor:KTColor_lightGray
                                       textAlignment:NSTextAlignmentRight];
    self.slider = [[UISlider alloc]init];
    self.slider.maximumValue = [[AudioPlayer instance].currentAudio.audioLong floatValue];
    self.slider.minimumValue = 0;
    self.slider.value = 0;
    self.slider.minimumTrackTintColor = KTColor_MainOrange;
    self.slider.maximumTrackTintColor = Audio_progessWhite;
    self.slider.thumbTintColor = KTColor_MainOrange;
    [self.slider addTarget:self action:@selector(pressSlider) forControlEvents:UIControlEventValueChanged];
    
    self.totalTime = [KTFactory creatLabelWithText:@"1:45"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    
    self.listBtn = [KTFactory creatPlayButtonWithImage:@"play_list" title:@"列表"];
    self.textBtn = [KTFactory creatPlayButtonWithImage:@"play_draft" title:@"文稿"];
    self.likeBtn = [KTFactory creatPlayButtonWithImage:@"playunlike" title:@"赞(10)"];
    [self.likeBtn setImage:[UIImage imageNamed:@"play_ like"] forState:UIControlStateSelected];
    self.downLoadBtn = [KTFactory creatPlayButtonWithImage:@"play_download" title:@"下载"];
    [self.downLoadBtn setImage:[UIImage imageNamed:@"play_downover"] forState:UIControlStateSelected];
    self.moreBtn = [KTFactory creatPlayButtonWithImage:@"icon_more" title:@"更多"];
    
    self.playList = [[PlayListView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    self.playList.delegate = self;
    self.MoreView = [[PlayerMoreView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    self.closeList = [[PlayCloseListView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [bgImgView addSubview:self.titleLabel];
    [bgImgView addSubview:self.tagLabel];
    [bgImgView addSubview:self.audioImg];
    [bgImgView addSubview:self.currntNum];
    [bgImgView addSubview:self.playBtn];
    [bgImgView addSubview:self.backButton];
    [bgImgView addSubview:self.upAudio];
    [bgImgView addSubview:self.nextAudio];
    [bgImgView addSubview:self.advanceButton];
    [bgImgView addSubview:self.currentTime];
    [bgImgView addSubview:self.slider];
    [bgImgView addSubview:self.totalTime];
    [bgImgView addSubview:self.listBtn];
    [bgImgView addSubview:self.textBtn];
    [bgImgView addSubview:self.likeBtn];
    [bgImgView addSubview:self.downLoadBtn];
    [bgImgView addSubview:self.moreBtn];
    [self.audioImg addSubview:self.audioPhoto];
    [bgImgView addSubview:self.playList];
    [bgImgView addSubview:self.MoreView];
    [bgImgView addSubview:self.shareView];
    [bgImgView addSubview:self.closeList];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(100)));
        make.right.equalTo(@(Anno750(-100)));
        make.top.equalTo(@(Anno750(20) + 20));
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(30) + 64));
    }];
    [self.audioImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.tagLabel.mas_bottom).offset(Anno750(36));
        make.width.equalTo(@(Anno750(552)));
        make.height.equalTo(@(Anno750(552)));
    }];
    [self.currntNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.audioImg.mas_bottom).offset(Anno750(54));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.currntNum.mas_bottom).offset(Anno750(60));
        make.width.equalTo(@(Anno750(138)));
        make.height.equalTo(@(Anno750(138)));
    }];
    [self.upAudio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.right.equalTo(self.playBtn.mas_left).offset(-Anno750(68));
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(70)));
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.upAudio.mas_left).offset(Anno750(-40));
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.width.equalTo(@(Anno750(50)));
        make.height.equalTo(@(Anno750(50)));
    }];
    [self.nextAudio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(Anno750(68));
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(70)));
    }];
    [self.advanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.left.equalTo(self.nextAudio.mas_right).offset(Anno750(40));
        make.height.equalTo(@(Anno750(50)));
        make.width.equalTo(@(Anno750(50)));
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Anno750(500)));
        make.centerX.equalTo(@0);
        make.top.equalTo(self.playBtn.mas_bottom).offset(Anno750(48));
        make.height.equalTo(@(Anno750(10)));
    }];
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_left).offset(Anno750(-10));
        make.centerY.equalTo(self.slider.mas_centerY);
    }];
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_right).offset(Anno750(10));
        make.centerY.equalTo(self.slider.mas_centerY);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(Anno750(110));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(90)));
        make.width.equalTo(@(PlayWidth));
    }];
    [self.textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.right.equalTo(self.likeBtn.mas_left);
        make.height.equalTo(@(Anno750(90)));
        make.width.equalTo(@(PlayWidth));
    }];
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.left.equalTo(@0);
        make.height.equalTo(@(Anno750(90)));
        make.width.equalTo(@(PlayWidth));
    }];
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.left.equalTo(self.likeBtn.mas_right);
        make.height.equalTo(@(Anno750(90)));
        make.width.equalTo(@(PlayWidth));
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeBtn.mas_centerY);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(90)));
        make.width.equalTo(@(PlayWidth));
    }];
    [self.audioPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(340)));
        make.width.equalTo(@(Anno750(340)));
    }];
    
    [self.playBtn addTarget:self action:@selector(musicPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(reduceMusicTime) forControlEvents:UIControlEventTouchUpInside];
    [self.advanceButton addTarget:self action:@selector(addMusicTime) forControlEvents:UIControlEventTouchUpInside];
    [self.upAudio addTarget:self action:@selector(upwardAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.nextAudio addTarget:self action:@selector(nextAudioClick) forControlEvents:UIControlEventTouchUpInside];
    [self.listBtn addTarget:self action:@selector(showPlayList) forControlEvents:UIControlEventTouchUpInside];
    [self.textBtn addTarget:self action:@selector(checkAudioText) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
    [self.downLoadBtn addTarget:self action:@selector(downLoadAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self.MoreView.shareButton addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.MoreView.closedButton addTarget:self action:@selector(showCloseList) forControlEvents:UIControlEventTouchUpInside];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tick{
    
    int duarTime = [[AudioPlayer instance].audioPlayer duration];
    int progress = [[AudioPlayer instance].audioPlayer progress];
    
    self.currentTime.text = [KTFactory getTimeStingWithCurrentTime:progress andTotalTime:duarTime];
    self.totalTime.text = [KTFactory getTimeStingWithCurrentTime:duarTime andTotalTime:duarTime];
    
    self.slider.value = progress;
}
#pragma mark - 获取音频详情
- (void)getAudioDetail{
    HomeTopModel * model = [AudioPlayer instance].currentAudio;
    if (!model.audioId || !model.relationType || !model.relationId) {
        return;
    }
    NSDictionary * params = @{
                              @"audioId":model.audioId,
                              @"relationType":model.relationType,
                              @"relationId":model.relationId
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_AudioDetail complete:^(id result) {
        self.newmodel = [[HomeTopModel alloc]initWithDictionary:result];
        [[HistorySql sql] updateAudioWithModel:self.newmodel];
        [self updateUIWithModel:self.newmodel];
    } errorBlock:^(KTError *error) {
        
    }];
    
}

#pragma mark - 弹出播放列表
- (void)showPlayList{
    [self.playList show];
}
#pragma mark - 查看文档
- (void)checkAudioText{
    WKWebViewController * webVC = [[WKWebViewController alloc]init];
    webVC.model = self.newmodel ? self.newmodel : [AudioPlayer instance].currentAudio;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - 弹出更多列表
- (void)showMoreView{
    [self.MoreView show];
}
#pragma mark - 弹出分享列表
- (void)showShareView{
    [self.MoreView disMiss];
    HomeTopModel * Audio = self.newmodel ? self.newmodel : [AudioPlayer instance].currentAudio;
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = Audio.audioName;
    model.shareDesc = Audio.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Audio.thumbnail]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@/type/%@/rid/%@",Base_Url,Page_ShareAudio,Audio.audioId,@1,Audio.audioId];
    [self.shareView updateWithShareModel:model];
    [self.shareView show];
}
#pragma mark - 弹出关闭列表
- (void)showCloseList{
    [self.MoreView disMiss];
    [self.closeList show];
}
#pragma mark - 音频播放
- (void)musicPlay:(UIButton *)btn{
    [[AudioPlayer instance] audioResume];
    if (btn.selected) {
        [self animationStop];
    }else{
        [self animationResume];
    }
    btn.selected = !btn.selected;
}
#pragma mark - 后退15秒
- (void)reduceMusicTime{
    [[AudioPlayer instance] backSongTime];
}
#pragma mark - 前进15秒
- (void)addMusicTime{
    [[AudioPlayer instance] forwardSongTime];
}
#pragma mark - 上一曲
- (void)upwardAudio{
    [[AudioPlayer instance] upwardAudio];
}
- (void)playUpAudio:(BOOL)canPlay{
    if (canPlay) {
        [self getAudioDetail];
    }else{
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"已经是第一首了" duration:1.0f];
    }
}

#pragma mark - 下一曲
- (void)nextAudioClick{
    [[AudioPlayer instance] nextAudio];
}
- (void)playNextAudio:(BOOL)canPlay isOver:(BOOL)rec{
    if (canPlay) {
        [self getAudioDetail];
    }else{
        if (rec) {
            [self musicPlay:self.playBtn];
            [[AudioPlayer instance].audioPlayer stop];
        }
    }
}
#pragma mark - 下载歌曲
- (void)downLoadAudio:(UIButton *)btn{
    if (btn.selected) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"本地音频，无需下载" duration:1.0f];
    }else{
        HomeTopModel * model = self.newmodel ? self.newmodel : [AudioPlayer instance].currentAudio;
        [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:@[model]];
    }
    
}
#pragma mark - 下载完成
- (void)audioDownLoadOver{
    self.downLoadBtn.selected = YES;
    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"音频下载完成" duration:1.0f];
}
#pragma mark - 点赞
- (void)likeButtonClick:(UIButton *)button{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        HomeTopModel * model = [AudioPlayer instance].currentAudio;
        NSDictionary * params = @{
                                  //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
                                  @"relationType":model.relationType,
                                  @"relationId":model.relationId,
                                  @"keyId":model.audioId,
                                  @"nickName":[UserManager manager].info.NICKNAME
                                  };
        NSString * pageUrl = Page_AddLike;
        if (button.selected) {
            pageUrl = Page_DelLike;
        }
        [self showLoadingCantClear:YES];
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:button.selected ? @"取消成功":@"点赞成功" duration:1.0f];
            HomeTopModel * model = self.newmodel ? self.newmodel : [AudioPlayer instance].currentAudio;
            model.isprase = button.selected;
            if (button.selected) {
                model.praseNum = @([model.praseNum intValue] - 1);
            }else{
                model.praseNum = @([model.praseNum intValue] + 1);
            }
            [self.likeBtn setTitle:[NSString stringWithFormat:@"赞(%@)",model.praseNum] forState:UIControlStateNormal];
            button.selected = !button.selected;
            
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
        }];
    }
    
}
#pragma mark - 滑动进度条改标歌曲进度
- (void)pressSlider{
    [[AudioPlayer instance] changePlayeAudioTime:self.slider.value];
}
- (void)playAudio{
    if ([AudioPlayer instance].audioPlayer.state != STKAudioPlayerStatePaused) {
        self.playBtn.selected = YES;
        [self animationResume];
    }else{
        self.playBtn.selected = NO ;
        [self animationStop];
    }
    if (!self.isFromRoot) {
        [[AudioPlayer instance] audioPlay:[AudioPlayer instance].currentAudio];
    }
    
    [self updateUIWithModel:[AudioPlayer instance].currentAudio];
}
#pragma mark - 添加动画
- (void)audioImageAnimtion{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 20.0f;
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.audioImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma 暂停动画
- (void)animationStop
{
    CALayer *layer = self.audioImg.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}
#pragma 继续动画
- (void)animationResume
{
    CALayer *layer = self.audioImg.layer;
    CFTimeInterval pauseTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSince = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    layer.beginTime = timeSince;
}
#pragma mark - 刷新方法
- (void)updateUIWithModel:(HomeTopModel *)model{
    self.likeBtn.selected = model.isprase;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"赞(%@)",model.praseNum] forState:UIControlStateNormal];
    [self.audioPhoto sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    self.titleLabel.text = model.audioName;
    self.tagLabel.text = [AudioPlayer instance].currentAudio.tagString.length == 0 ? @"" : [NSString stringWithFormat:@"#%@",[AudioPlayer instance].currentAudio.tagString];
    self.currntNum.text = [NSString stringWithFormat:@"正在播放  %d/%ld",[[AudioPlayer instance] currentSortNum],
                           (unsigned long)[AudioPlayer instance].playList.count];
    NSNumber * downStatus = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
    self.downLoadBtn.selected = [downStatus intValue] == 2 ? YES : NO;
    
}
- (void)playAudioNeedUpdate:(HomeTopModel *)model{
    [self updateUIWithModel:model];
    [self getAudioDetail];
}

@end

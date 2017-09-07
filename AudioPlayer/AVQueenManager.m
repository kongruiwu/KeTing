//
//  AVQueenPlayer.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AVQueenManager.h"
#import "RootViewController.h"



@implementation AVQueenManager

+ (instancetype)Manager{
    static AVQueenManager * Manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Manager = [[AVQueenManager alloc]init];
        Manager.playAudioIndex = 0;
        id num = [[NSUserDefaults standardUserDefaults] objectForKey:@"current"];
        if (num) {
            Manager.showFoot = YES;
            NSNumber * audioid = (NSNumber *)num;
            HomeTopModel * model = [[HistorySql sql] getHometopModel:audioid];
            Manager.playList = [NSMutableArray arrayWithObject:model];
        }else{
            Manager.showFoot = NO;
        }
        Manager.imgView = [KTFactory creatImageViewWithImage:@""];
        Manager.endPlaying = YES;
    });
    return Manager;
}

- (HomeTopModel *)currrentAudio{
    HomeTopModel * model = self.playList[self.playAudioIndex];
    return model;
}

- (void)playAudios:(NSArray *)audios{
    //用户点击 更改播放列表时 要及时上报 播放历史
    if (self.KRPlayer) {
        [self AddListenListoryIsOver:NO];
    }
    
    self.playAudioIndex = 0;
    self.playList = [NSMutableArray arrayWithArray:audios];
    HomeTopModel * model = audios[0];
    [self playAudioWithModel:model];
}

- (void)playAudioList:(NSArray *)audios playAtIndex:(NSInteger)index{
    //用户点击 更改播放列表时 要及时上报 播放历史
    if (self.KRPlayer) {
        [self AddListenListoryIsOver:NO];
    }
    self.playAudioIndex = index;
    self.playList = [NSMutableArray arrayWithArray:audios];
    HomeTopModel * model = audios[index];
    [self playAudioWithModel:model];
}

- (void)checkAudioPlayStatus{
    
    if ([self checkisPlaying]) {
        self.isPlaying = YES;
    }else{
        self.isPlaying = NO;
    }
    [self postNotionfation];
    
}
- (BOOL)checkisPlaying
{
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        return self.KRPlayer.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }else{
        return self.KRPlayer.player.rate > 0.5;
    }
}


- (void)setPlayList:(NSMutableArray *)playList{
    _playList = playList;
    for (int i = 0; i<_playList.count; i++) {
        HomeTopModel * model = _playList[i];
        NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
        if ([num integerValue] == 1000) {
            model.downStatus = 0;
        }else{
            model.downStatus = num;
        }
        if ([num integerValue] == 2) {
            NSString * localadd = [[SqlManager manager] checkAudioLocaltionAddressWithAudioid:model.audioId];
            model.localAddress = localadd;
        }
    }
}
#pragma mark - 播放器逻辑相关
/*
 *  需要及时更新当前播放audio，作为下次打开app时展示的记录
 *  需要更新音频的播放进度为1，更新音频的播放进度
 *  涉及到底部播放view展示，第一次进入时不展示，以后则一直展示，并同时刷新底部控件ui
 *  判断本地是否存在这个audio，存在则播放本地，不存在则播放网络音源
 *  音频播放时要通知ui进行刷新
 *  更新锁屏页界面
 *  更新播放页界面
 */
- (void)playAudioWithModel:(HomeTopModel *)model{
    self.endPlaying = NO;
    NSString * url = [self checkLocationHasAudio:model];
    [self playAudioWithAudioUrl:url];
    [self saveAudioPlayLongStatus:model];
    [self updateBottomPlayView];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default"]];
//    [self postNotionfation];
    
}
/**判断本地是否存在这个audio，存在则播放本地，不存在则播放网络音源*/
- (NSString *)checkLocationHasAudio:(HomeTopModel *)model{
    NSString * sourse ;
    if ([model.downStatus integerValue] == 2) {
        NSString * locatAdd = [[SqlManager manager] checkAudioLocaltionAddressWithAudioid:model.audioId];
        if (locatAdd.length >0) {
            sourse = [NSString stringWithFormat:@"file://%@/%@",HSCachesDirectory,model.audioId];
        }else{
            sourse = model.audioSource;
        }
    }else{
        sourse = model.audioSource;
    }
    return sourse;
}
/**更新播放进度  同时更新本地 记录的最后播放的一个音频*/
- (void)saveAudioPlayLongStatus:(HomeTopModel *)model{
    [[NSUserDefaults standardUserDefaults] setObject:model.audioId forKey:@"current"];
    
    model.playLong = @0;
    if ([[HistorySql sql] checkAudio:model.audioId]) {
        [[HistorySql sql] updatePlayLong:model.playLong withAudioID:model.audioId];
    }else{
        [[HistorySql sql] insertAudio:model];
    }
}

/**更新播放时长*/
- (void)saveAudioPlayLong:(int)value{
    HomeTopModel * model = self.playList[self.playAudioIndex];
    model.playLong = @(value);
    if ([[HistorySql sql] checkAudio:model.audioId]) {
        [[HistorySql sql] updatePlayLong:@(value) withAudioID:model.audioId];
    }else{
        [[HistorySql sql] insertAudio:model];
    }
}


#pragma mark - 音乐播放  界面更新相关
/**更新 是否展示底部播放控件*/
- (void)updateBottomPlayView{
    if (!self.showFoot) {
        self.showFoot = YES;
    }
}
/**发送通知 界面更新*/
- (void)postNotionfation{
    [[NSNotificationCenter defaultCenter] postNotificationName:AudioReadyPlaying object:nil];
}

- (void)playAudioWithAudioUrl:(NSString *)url{
    self.isPlaying = YES;
    if (self.KRPlayer) {
        [self.KRPlayer playAudioWithPlayUrl:url];
    }else{
        self.KRPlayer = [[KRAudioPlayer alloc]initWithPlayUrl:url];
        self.KRPlayer.delgate = self;
    }
}
#pragma mark - 上一曲  下一曲  或者制定某一曲
- (void)playAudioAtIndex:(NSInteger)index{
    
    [self saveAudioPlayLong:(int)self.bottomProgress];
    
    self.playAudioIndex = index;
    HomeTopModel * model = self.playList[self.playAudioIndex];
    [self playAudioWithModel:model];
}


- (void)playNextAudio{
    
    [self saveAudioPlayLong:(int)self.bottomProgress];
    
    if (self.playAudioIndex == self.playList.count - 1) {
        [self showErrorMessage:@"已经是最后一首了"];
    }else{
        self.playAudioIndex += 1;
        HomeTopModel * model = self.playList[self.playAudioIndex];
        [self playAudioWithModel:model];
    }
}

- (void)playUpForwardAudio{
    [self saveAudioPlayLong:(int)self.bottomProgress];
    
    if (self.playAudioIndex == 0) {
        [self showErrorMessage:@"已经是第一首了"];
    }else{
        self.playAudioIndex -= 1;
        HomeTopModel * model = self.playList[self.playAudioIndex];
        [self playAudioWithModel:model];
    }
}
#pragma mark - 快进 倒退
- (void)playAddTimeTentyFive{
    [self.KRPlayer seekAddTime:15];
}
- (void)playReduceTimeTentyFive{
    
    [self.KRPlayer seekAddTime:-15];
}
- (void)playTheSeekValue:(float)value{
    [self.KRPlayer seekToTime:value];
}

- (void)showErrorMessage:(NSString *)str{
    [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:str duration:1.0f];
}
#pragma mark - 进度条等ui相关属性
- (float)progress{
    if (self.KRPlayer && !self.endPlaying) {
        return self.KRPlayer.progress;
    }else{
        return 0;
    }
}
- (float)duation{
    if (self.KRPlayer && !self.endPlaying) {
        return self.KRPlayer.duation;
    }else{
        return 0;
    }
}
- (float)bottomProgress{
    if (self.KRPlayer && !self.endPlaying) {
        if (isnan(self.duation)) {
            return 0;
        }
        return ((self.progress * 100)/self.duation);
    }
    return 0;
}

- (int)listCount{
    if (self.playList) {
        return (int)self.playList.count;
    }else{
        return 0;
    }
}
#pragma mark - 播放器暂停与恢复
- (void)resume{
    if (self.endPlaying) {
        [self playAudioAtIndex:self.playAudioIndex];
    }else{
        self.isPlaying = YES;
        [self.KRPlayer resume];
    }
    [self postNotionfation];
}
- (void)pause{
    self.isPlaying = NO;
    [self.KRPlayer pause];
    [self postNotionfation];
}


#pragma mark - 设置变速

- (void)setRate:(CGFloat)rate{
    _rate = rate;
    self.KRPlayer.rate = _rate;
}

#pragma mark - 播放器状态
/**音频开始播放*/
- (void)AudioPlayIsBeginPlay{
    [self postNotionfation];
}
/**音频播放失败*/
- (void)AudioPlayDidFaild{
    NSLog(@"audio failed");
}
/**音频播放未知状态*/
- (void)AuidoPlayWithUnKnowStatus{
    NSLog(@"audio unknowstatus");
}
/**音频播放卡顿*/
- (void)AudioPlayDiscontinuously{
    
}
/**音频播放完毕*/
- (void)AudioPlayOvered{
    //用户播放完成后  上报播放记录
    [self AddListenListoryIsOver:YES];
    
    [self saveAudioPlayLong:100];
    
    //当设置了自动关闭 则自动关闭
    if (self.closeTime == CloseTimeThisAudio) {
        [self pause];
    }else{
        //若播放完当前列表所有音频  则需要更新界面为 重置界面
        if (self.playAudioIndex + 1 == self.listCount) {
            self.isPlaying = NO;
            self.endPlaying = YES;
            [self postNotionfation];
        }else{
           [self playNextAudio];
        }
        
    }
    
}
/**音频播放状态下 出现错误*/
- (void)AudioPlayingError{
    NSLog(@"audio error");
}

#pragma mark  - 自动关闭

- (void)setCloseTime:(CloseTime)closeTime{
    _closeTime = closeTime;
    self.closeMin = 0;
    switch (_closeTime) {
        case CloseTimeNone:
        {
            if (self.timer) {//关闭定时器
                [self.timer invalidate];
                self.timer = nil;
            }
        }
            break;
        case CloseTimeThisAudio:
        {
            //当前音乐播放完毕   再播放完成代理中使用
        }
            break;
        case CloseTime30min:
        case CloseTime60min:
        case CloseTime90min:
        {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(closeAudioCountAdd) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
            break;
            
        default:
            break;
    }
}
- (void)closeAudioCountAdd{
    self.closeMin += 1;
    BOOL rec = NO;
    switch (self.closeTime) {
        case CloseTime30min:
            rec = self.closeMin == 30 ? YES :NO;
            break;
        case CloseTime60min:
            rec = self.closeMin == 60 ? YES :NO;
            break;
        case CloseTime90min:
            rec = self.closeMin == 90 ? YES :NO;
            break;
        default:
            break;
    }
    if (rec) {
        [self AddListenListoryIsOver:NO];
        [self pause];
    }
}
#pragma mark - 上传用户播放历史
- (void)AddListenListoryIsOver:(BOOL)rec{
    
    HomeTopModel * model = self.playList[self.playAudioIndex];
    
    NSDictionary * params = @{
                              @"nickName":INCASE_EMPTY([UserManager manager].info.NICKNAME, @""),
                              @"relationType":model.relationType ? model.relationType : @1,
                              @"relationId":model.relationId ? model.relationId : @45,
                              @"keyId":model.audioId,
                              @"playLong":rec?model.audioLong:@(self.progress),
                              @"audioLong":model.audioLong
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddListory complete:^(id result) {
        
    } errorBlock:^(KTError *error) {
        
    }];
}

- (void)setPlayingInfo {

    MPMediaItemArtwork * artWork = [[MPMediaItemArtwork alloc] initWithImage:self.imgView.image];
    NSDictionary *dic = @{MPMediaItemPropertyTitle:self.currrentAudio.audioName,
                          MPMediaItemPropertyArtist:self.currrentAudio.anchorName ? self.currrentAudio.anchorName: @"可听",
                          MPMediaItemPropertyArtwork:artWork,
                          MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:CMTimeGetSeconds(self.KRPlayer.player.currentItem.duration)],
                          MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithDouble:CMTimeGetSeconds(self.KRPlayer.player.currentItem.currentTime)]
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}


@end

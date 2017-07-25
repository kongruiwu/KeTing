//
//  AudioPlayer.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioPlayer.h"
#import "RootViewController.h"
#import "HistorySql.h"
#import "AudioDownLoader.h"
@implementation AudioPlayer

+ (instancetype)instance{
    static AudioPlayer * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[AudioPlayer alloc]init];
        [player AudioPlayerReady];
        player.showFoot = NO;
    });
    return player;
}


- (void)AudioPlayerReady{
    self.audioPlayer = [[STKAudioPlayer alloc]init];
    self.audioPlayer.delegate = self;
    self.playList = [NSMutableArray new];
    
}

- (void)audioPlay:(HomeTopModel *)model{
    
    model.playLong = @0;
    if ([[HistorySql sql] checkAudio:model.audioId]) {
        [[HistorySql sql] updatePlayLong:model.playLong withAudioID:model.audioId];
    }else{
        [[HistorySql sql] insertAudio:model];
    }
    //播放音频
    if (!self.showFoot) {
        self.showFoot = YES;
    }
    if ([model.downStatus integerValue] == 2) {
        NSString * locatAdd = [[SqlManager manager] checkAudioLocaltionAddressWithAudioid:model.audioId];
        if (locatAdd.length>0) {
            NSString * path = [NSString stringWithFormat:@"file://%@/%@",HSCachesDirectory,model.audioId];
            [self.audioPlayer play:path];
        }else{
            [self.audioPlayer play:model.audioSource];
        }
    }else{
        [self.audioPlayer play:model.audioSource];
    }
    self.currentAudio = model;
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.playFoot changePlayStatus];
    
    //通知首页刷新头条播放状态
    if ([self.delegate respondsToSelector:@selector(AudioPlayerPlayStatusReady)]) {
        [self.delegate AudioPlayerPlayStatusReady];
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

- (void)audioResume{
    if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
        [self.audioPlayer resume];
    }else{
        [self.audioPlayer pause];
        [[HistorySql sql] updatePlayLong:@([self audioProgress]) withAudioID:self.currentAudio.audioId];
    }
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.playFoot changePlayStatus];
}
- (int)audioProgress{
    int duarTime = [self.audioPlayer duration];
    int progress = [self.audioPlayer progress];
    if (progress == 0) {
        return 0;
    }
    int playLong = (int)((progress * 100)/duarTime);
    return playLong;
}
- (int)currentSortNum{
    return (int)[self.playList indexOfObject:self.currentAudio] + 1;
}
- (void)nextAudio{
    [self nextAudioIsOver:NO];
}
- (void)nextAudioIsOver:(BOOL)rec{
    int index = [self currentSortNum];
    //若当前为最后一首 则播放列表第一项
    if (index != self.playList.count) {
        if (self.audioPlayer.progress >0 ) {
            [[HistorySql sql] updatePlayLong:@([self audioProgress]) withAudioID:self.currentAudio.audioId];
        }
        self.currentAudio = self.playList[index];
        [self audioPlay:self.currentAudio];
        if ([self.delegate respondsToSelector:@selector(playNextAudio: isOver:)]) {
            [self.delegate playNextAudio:YES isOver:rec];
        }
    }else{
        if (rec) {
            if ([self.delegate respondsToSelector:@selector(playNextAudio: isOver:)]) {
                [self.delegate playNextAudio:NO isOver:rec];
            }
        }else{
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"已经是最后一首了" duration:1.0f];
        }
        
    }
}
- (void)upwardAudio{
    int index = [self currentSortNum];
    //当前为第一首 则播放 列表中最后一项
    if (index != 1) {
        if (self.audioPlayer.progress >0 ) {
            [[HistorySql sql] updatePlayLong:@([self audioProgress]) withAudioID:self.currentAudio.audioId];
        }
        self.currentAudio =self.playList[index - 2];
        [self audioPlay:self.currentAudio];
        if ([self.delegate respondsToSelector:@selector(playUpAudio:)]) {
            [self.delegate playUpAudio:YES];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(playUpAudio:)]) {
            [self.delegate playUpAudio:NO];
        }
    }
    
}
- (void)backSongTime{
    int current = self.audioPlayer.progress;
    if (current < 15) {
        [self.audioPlayer seekToTime:0];
    }else{
        [self.audioPlayer seekToTime:current - 15];
    }
}
- (void)forwardSongTime{
    int duration = self.audioPlayer.duration;
    int current = self.audioPlayer.progress;
    if (current + 15 > duration) {
        [self.audioPlayer seekToTime:duration];
    }else{
        [self.audioPlayer seekToTime:current +15];
    }
}
- (void)changePlayeAudioTime:(int)progress{
    [self.audioPlayer seekToTime:progress];
}


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
        [self.audioPlayer stop];
    }
}
// 当播放器 状态发生改变的时候调用，暂停-开始播放都会调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
//    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"歌曲暂停了" duration:1.0f];
}
// 引发的意外和可能发生的不可恢复的错误，极少概率会调用。  就是此歌曲不能加载，或者url是不可用的
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"糟糕，音频发生错了" duration:1.0f];
    [self nextAudio];
}
//当一个项目开始播放调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{

}
// 一般是歌曲快结束提前5秒调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    [[HistorySql sql] updatePlayLong:@(100) withAudioID:self.currentAudio.audioId];
}
//当一个项目完成后，就调用
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    switch (stopReason) {
        case STKAudioPlayerStopReasonNone:
            //用户操作  进行的动作 上一曲 下一曲
            break;
        case STKAudioPlayerStopReasonEof:
            [self nextAudioIsOver:YES];
            break;
        case STKAudioPlayerStopReasonUserAction:
            NSLog(@"111");
            break;
        case STKAudioPlayerStopReasonPendingNext:
            NSLog(@"111");
            break;
        case STKAudioPlayerStopReasonDisposed:
            NSLog(@"111");
            break;
        case STKAudioPlayerStopReasonError:
            NSLog(@"111");
            break;
        default:
            break;
    }
    if (self.closeTime == CloseTimeThisAudio) {
        [self.audioPlayer stop];
    }
}



@end

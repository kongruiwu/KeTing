//
//  AudioPlayer.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioPlayer.h"
#import "SqlManager.h"
@implementation AudioPlayer

+ (instancetype)instance{
    static AudioPlayer * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[AudioPlayer alloc]init];
        [player AudioPlayerReady];
    });
    return player;
}


- (void)AudioPlayerReady{
    self.audioPlayer = [[STKAudioPlayer alloc]init];
    self.audioPlayer.delegate = self;
    self.playList = [NSMutableArray new];
}

- (void)audioPlay:(HomeTopModel *)model{
    NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
    if ([num integerValue] == 2) {
        NSString * localadd = [[SqlManager manager] checkAudioLocaltionAddressWithAudioid:model.audioId];
        if (localadd.length>0) {
            [self.audioPlayer play:localadd];
        }else{
            [self.audioPlayer play:model.audioSource];
        }
    }else{
        [self.audioPlayer play:model.audioSource];
    }
    
}

- (void)audioResume{
    if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
        [self.audioPlayer resume];
    }else{
        [self.audioPlayer pause];
    }
}
- (int)currentSortNum{
    return (int)[self.playList indexOfObject:self.currentAudio] + 1;
}

- (void)nextAudio{
    int index = [self currentSortNum];
    //若当前为最后一首 则播放列表第一项
    if (index == self.playList.count) {
        self.currentAudio = [self.playList firstObject];
    }else{
        self.currentAudio = self.playList[index];
    }
    [self audioPlay:self.currentAudio];
}
- (void)upwardAudio{
    int index = [self currentSortNum];
    //当前为第一首 则播放 列表中最后一项
    if (index == 1) {
        self.currentAudio =[self.playList lastObject];
    }else{
        self.currentAudio =self.playList[index - 2];
    }
    [self audioPlay:self.currentAudio];
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
// 当播放器 状态发生改变的时候调用，暂停-开始播放都会调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
//    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"歌曲暂停了" duration:1.0f];
}
// 引发的意外和可能发生的不可恢复的错误，极少概率会调用。  就是此歌曲不能加载，或者url是不可用的
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    
}
//当一个项目开始播放调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
//    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"歌曲开始了" duration:1.0f];
}
// 一般是歌曲快结束提前5秒调用
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
//    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"歌曲快结束了 还有 5秒钟" duration:1.0f];
}
//当一个项目完成后，就调用
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
//    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"歌曲结束了" duration:1.0f];
}


@end

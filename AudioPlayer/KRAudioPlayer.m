//
//  KRAudioPlayer.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/31.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "KRAudioPlayer.h"
#import <UIKit/UIKit.h>
@interface KRAudioPlayer()

@property (nonatomic) BOOL hasAddNot;

@end


@implementation KRAudioPlayer
/** init */
- (instancetype)initWithPlayUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.playAsset = [[AVURLAsset alloc]initWithURL:[NSURL URLWithString:url] options:nil];
        self.playerItem = [[AVPlayerItem alloc]initWithAsset:self.playAsset];
        [self addAudioPlayObserver];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 10) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
        [self addNotificationCenter];
        [self.player play];
    }
    return self;
}
- (instancetype)initWithPlayItem:(AVPlayerItem *)item{
    self = [super init];
    if (self) {
        self.playerItem = item;
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        [self addAudioPlayObserver];
        [self addNotificationCenter];
    }
    return self;
}
- (instancetype)initWithAudioUrlAsset:(AVURLAsset *)asset{
    self = [super init];
    if (self) {
        self.playAsset = asset;
        self.playerItem = [[AVPlayerItem alloc]initWithAsset:self.playAsset];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        [self addAudioPlayObserver];
        [self addNotificationCenter];
    }
    return self;
}
/**播放其它音频*/
- (void)playAudioWithPlayUrl:(NSString *)url{
    self.playAsset = [[AVURLAsset alloc]initWithURL:[NSURL URLWithString:url] options:nil];
    AVPlayerItem * item = [[AVPlayerItem alloc]initWithAsset:self.playAsset];
    [self playAudioWithPlayItem:item];
}
- (void)playAudioWithPlayAsset:(AVURLAsset *)asset{
    self.playAsset = asset;
    AVPlayerItem * item = [[AVPlayerItem alloc]initWithAsset:self.playAsset];
    [self playAudioWithPlayItem:item];
}
- (void)playAudioWithPlayItem:(AVPlayerItem *)playItem{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    self.playerItem = playItem;
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self addAudioPlayObserver];
    [self.player play];
}

- (void)pause{
    
    [self.player pause];
    

}
- (void)resume{
    
    [self.player play];

}


/**playItem 添加观察者  监控其播放属性更改*/
- (void)addAudioPlayObserver{
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:
                [self audioDidReadyToPlay];
                break;
            case AVPlayerStatusFailed:
                [self audioDidLoadFailed];
                break;
            case AVPlayerStatusUnknown:
                [self audioCanntLoadWithUnknowStatus];
                break;
            default:
                break;
        }
    }
}

- (void)audioDidReadyToPlay{
    
    if ([self.delgate respondsToSelector:@selector(AudioPlayIsBeginPlay)]) {
        [self.delgate AudioPlayIsBeginPlay];
    }
}
- (void)audioDidLoadFailed{
    
    if ([self.delgate respondsToSelector:@selector(AudioPlayDidFaild)]) {
        [self.delgate AudioPlayDidFaild];
    }
}
- (void)audioCanntLoadWithUnknowStatus{
    
    if ([self.delgate respondsToSelector:@selector(AuidoPlayWithUnKnowStatus)]) {
        [self.delgate AuidoPlayWithUnKnowStatus];
    }
}
/**设置播放速度*/
- (void)setRate:(CGFloat)rate{
    _rate = rate;
    self.player.rate = rate;
}
/**快进 或者 后退 value 秒*/
- (void)seekAddTime:(float)value{
    
    float currentPlayTime = (double)self.playerItem.currentTime.value/ self.playerItem.currentTime.timescale;
    float totalDuration = CMTimeGetSeconds(self.playerItem.duration);
    
    int currentValue = currentPlayTime + value;
    if (currentValue < 0 ) {
        [self seekToTime:0];
    }else if(currentValue > totalDuration){
        [self seekToTime:totalDuration - 1];
    }else{
        [self seekToTime:currentValue];
    }
}
- (void)seekToTime:(float)value{

    [self.player seekToTime:CMTimeMake(value, 1)];
    
}

- (void)addNotificationCenter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithDiscontinuouslyStatus) name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithdPlayToEndTimeStatus) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithErrorStatus:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:@1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithErrorStatus:) name:AVPlayerItemPlaybackStalledNotification object:@2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithErrorStatus:) name:AVPlayerItemNewAccessLogEntryNotification object:@3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithErrorStatus:) name:AVPlayerItemNewErrorLogEntryNotification object:@4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioPlayWithErrorStatus:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:@5];
    _hasAddNot = YES;
    
}
/**移除所有通知中心*/
- (void)removeAllNotifion{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _hasAddNot = NO;
}

/**播放卡顿*/
- (void)AudioPlayWithDiscontinuouslyStatus{
    if ([self.delgate respondsToSelector:@selector(AudioPlayDiscontinuously)]) {
        [self.delgate AudioPlayDiscontinuously];
    }
}
/**播放完毕*/
- (void)AudioPlayWithdPlayToEndTimeStatus{
    if ([self.delgate respondsToSelector:@selector(AudioPlayOvered)]) {
        [self.delgate AudioPlayOvered];
    }
}
/**播放器出现错误*/
- (void)AudioPlayWithErrorStatus:(NSNumber *)num{
    if ([self.delgate respondsToSelector:@selector(AudioPlayingError)]) {
        [self.delgate AudioPlayingError];
    }
}

- (float)duation{
    return CMTimeGetSeconds(self.playerItem.duration);
}
- (float)progress{
    float currentPlayTime = (double)self.playerItem.currentTime.value/ self.playerItem.currentTime.timescale;
    return currentPlayTime;
}

@end

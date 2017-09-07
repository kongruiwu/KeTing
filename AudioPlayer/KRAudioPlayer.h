//
//  KRAudioPlayer.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/31.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayDelegate <NSObject>
/**音频开始播放*/
- (void)AudioPlayIsBeginPlay;
/**音频播放失败*/
- (void)AudioPlayDidFaild;
/**音频播放未知状态*/
- (void)AuidoPlayWithUnKnowStatus;
/**音频播放卡顿*/
- (void)AudioPlayDiscontinuously;
/**音频播放完毕*/
- (void)AudioPlayOvered;
/**音频播放状态下 出现错误*/
- (void)AudioPlayingError;

@end

@interface KRAudioPlayer : NSObject
/**音频缓存文件*/
@property (nonatomic, strong) AVURLAsset * playAsset;
/**音频播放基础文件*/
@property (nonatomic, strong) AVPlayerItem * playerItem;
/**音频播放器*/
@property (nonatomic, strong) AVPlayer * player;
/**播放速度*/
@property (nonatomic) CGFloat rate;
/**总时间*/
@property (nonatomic) float duation;
/**当前进度*/
@property (nonatomic) float progress;



@property (nonatomic, assign) id<AudioPlayDelegate> delgate;


- (instancetype)initWithPlayUrl:(NSString *)url;

- (instancetype)initWithPlayItem:(AVPlayerItem *)item;

- (instancetype)initWithAudioUrlAsset:(AVURLAsset *)asset;


- (void)playAudioWithPlayUrl:(NSString *)url;
- (void)playAudioWithPlayAsset:(AVURLAsset *)asset;
- (void)playAudioWithPlayItem:(AVPlayerItem *)playItem;


- (void)pause;
- (void)resume;


- (void)seekAddTime:(float)value;
- (void)seekToTime:(float)value;


@end

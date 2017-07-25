//
//  AudioPlayer.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/8.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKAudioPlayer.h>
//音频model
#import "HomeTopModel.h"

typedef NS_ENUM(NSInteger, CloseTime){
    CloseTimeNone = 0   ,  //没有倒计时
    CloseTimeThisAudio  ,  //播放完当前音频
    CloseTime30min      ,   //30分钟
    CloseTime60min      ,   //60分钟
    CloseTime90min          //90分钟
};
@protocol AudioPlayerDelegate <NSObject>

@optional
- (void)AudioPlayerPlayStatusReady;
- (void)playNextAudio:(BOOL)canPlay isOver:(BOOL)rec;
- (void)playUpAudio:(BOOL)canPlay;

@end

@interface AudioPlayer : NSObject<STKAudioPlayerDelegate>

/**播放器*/
@property (nonatomic, strong) STKAudioPlayer * audioPlayer;
/**播放列表*/
@property (nonatomic, strong) NSMutableArray * playList;
/**当前播放的音频*/
@property (nonatomic, strong) HomeTopModel * currentAudio;
/**是否展示底部播放器*/
@property (nonatomic, assign) BOOL showFoot;
/**自动关闭定时器*/
@property (nonatomic, strong) NSTimer * timer;
/**自动关闭时间*/
@property (nonatomic, assign) CloseTime closeTime;

@property (nonatomic, assign) id<AudioPlayerDelegate> delegate;
/**自动关闭时间*/
@property (nonatomic, assign) int closeMin;


/**player*/
+ (instancetype)instance;
/**后退15秒*/
- (void)backSongTime;
/**前进15秒*/
- (void)forwardSongTime;
/**播放歌曲的当前排名*/
- (int)currentSortNum;
/**下一曲*/
- (void)nextAudio;
/**上一曲*/
- (void)upwardAudio;
/**改变当前播放音频的播放进度*/
- (void)changePlayeAudioTime:(int)progress;
/**播放音频*/
- (void)audioPlay:(HomeTopModel *)model;
/**播放/暂停*/
- (void)audioResume;
/**百分比进度*/
- (int)audioProgress;





@end

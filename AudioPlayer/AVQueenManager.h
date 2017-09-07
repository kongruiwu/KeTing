//
//  AVQueenPlayer.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ConfigHeader.h"
#import "KRAudioPlayer.h"
#import "HomeTopModel.h"
#import "SqlManager.h"
#import "AudioDownLoader.h"
#import "HistorySql.h"
#import <MediaPlayer/MediaPlayer.h>


#define AudioReadyPlaying   @"AudioReadyPlaying"

//业务层
@interface AVQueenManager : NSObject<AudioPlayDelegate>
/**是否正在播放*/
@property (nonatomic, assign) BOOL isPlaying;
/**是否完成播放*/
@property (nonatomic, assign) BOOL endPlaying;
/**播放列表*/
@property (nonatomic, strong) NSMutableArray * playList;
/**当前播放所在位置*/
@property (nonatomic, assign) NSInteger playAudioIndex;
/**主播放器*/
@property (nonatomic, strong) KRAudioPlayer * KRPlayer;
/**是否展示底部播放控件*/
@property (nonatomic, assign) BOOL showFoot;
/**总时长*/
@property (nonatomic) float duation;
/**当前播放进度*/
@property (nonatomic) float progress;
/**底部播放 进度*/
@property (nonatomic) float bottomProgress;
/**播放列表数量*/
@property (nonatomic) int listCount;
/**播放速度*/
@property (nonatomic) CGFloat rate;

/**自动关闭定时器*/
@property (nonatomic, strong) NSTimer * timer;
/**自动关闭类型*/
@property (nonatomic, assign) CloseTime closeTime;
/**自动关闭时间*/
@property (nonatomic, assign) int closeMin;
/**当前播放的音频*/
@property (nonatomic, strong) HomeTopModel * currrentAudio;

@property (nonatomic, strong) UIImageView * imgView;


+ (instancetype)Manager;

- (void)playAudios:(NSArray *)audios;
- (void)playAudioList:(NSArray *)audios playAtIndex:(NSInteger)index;

- (void)playAudioAtIndex:(NSInteger)index;
- (void)playNextAudio;
- (void)playUpForwardAudio;
- (void)playTheSeekValue:(float)value;

- (void)playAddTimeTentyFive;
- (void)playReduceTimeTentyFive;

- (void)resume;
- (void)pause;


- (void)saveAudioPlayLong:(int)value;

- (void)setPlayingInfo;


- (void)checkAudioPlayStatus;
@end

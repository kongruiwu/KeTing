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


@interface AudioPlayer : NSObject<STKAudioPlayerDelegate>

/**播放器*/
@property (nonatomic, strong) STKAudioPlayer * audioPlayer;
/**播放列表*/
@property (nonatomic, strong) NSMutableArray * playList;
/**当前播放的音频*/
@property (nonatomic, strong) HomeTopModel * currentAudio;

@property (nonatomic, assign) BOOL showFoot;



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

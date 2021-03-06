//
//  AudioDownLoader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"
#import "SqlManager.h"
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AudioCashe"]
#define TemCachesPath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Temp"]
@protocol AudioDownLoadDelegate <NSObject>

@optional
- (void)showProgress:(NSString *)progress;

@required
- (void)audioDownLoadOver;


@end


@interface AudioDownLoader : NSObject<NSURLSessionDownloadDelegate>
/**下载列表*/
@property (nonatomic, strong) NSMutableArray * downLoadList;
/**已下载数据id*/
@property (nonatomic, strong) NSMutableArray * downLoaded;
/**未下载数据id*/
@property (nonatomic, strong) NSMutableArray * waitList;
/**正在下载数据id*/
@property (nonatomic, strong) NSNumber * currentID;
/**是否开启自动下载*/
@property (nonatomic, assign) BOOL autoDownLoad;

@property (nonatomic, strong) HomeTopModel * currentModel;

@property (nonatomic, assign) id <AudioDownLoadDelegate> delegate;
/**是否处于正在下载状态*/
@property (nonatomic) BOOL isDownLoading;


+ (instancetype)loader;
/**开始下载*/
- (void)downLoadAudioWithHomeTopModel:(NSArray *)topModels;
/**暂停下载*/
- (void)cancelDownLoading;
/**恢复下载*/
- (void)resumeDownLoading;
/**删除数据*/
- (void)deleteAudioWithLocalPath:(NSString *)LocalPath;

- (void)clearDownLoadingData;
@end

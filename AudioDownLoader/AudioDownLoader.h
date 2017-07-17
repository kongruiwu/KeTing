//
//  AudioDownLoader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AudioCashe"]
#define TemCachesPath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Temp"]
@interface AudioDownLoader : NSObject<NSURLSessionDownloadDelegate>
/**下载列表*/
@property (nonatomic, strong) NSMutableArray * downLoadList;
/**已下载数据id*/
@property (nonatomic, strong) NSMutableArray * downLoaded;
/**未下载数据id*/
@property (nonatomic, strong) NSMutableArray * waitList;
/**正在下载数据id*/
@property (nonatomic, strong) NSNumber * currentID;

@property (nonatomic, strong) HomeTopModel * currentModel;


+ (instancetype)loader;
/**开始下载*/
- (void)downLoadAudioWithHomeTopModel:(NSArray *)topModels;
/**暂停下载*/
- (void)cancelDownLoading;
/**恢复下载*/
- (void)resumeDownLoading;
@end

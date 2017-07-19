//
//  SqlManager.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"
#import <FMDB.h>
@interface SqlManager : NSObject

@property (nonatomic, strong) FMDatabase * PDO;

+ (instancetype)manager;
- (void)openDB;
/**添加数据*/
- (void)insertAudio:(HomeTopModel *)model;
/**更新下载状态*/
- (void)updateAudioDownStatus:(NSInteger)status withAudioId:(NSNumber *)audioID;
/**删除数据*/
- (void)deleteAudioWithID:(NSNumber *)audioID;
/**获取所有已下载列表*/
- (NSMutableArray *)getAllDownLoaderStatus;
/**获取下载状态*/
- (NSNumber *)checkDownStatusWithAudioid:(NSNumber *)audioID;
/**获取音频本地地址*/
- (NSString *)checkAudioLocaltionAddressWithAudioid:(NSNumber *)audioID;
/**获取正在下载状态下载音频*/
- (NSMutableArray *)getDownLoadingAudio;
/**获取未下载音频*/
- (NSMutableArray *)getWaitDownLoadingAudios;
/**更新音频本地地址*/
- (void)updateAudioLocaltionAddress:(NSString *)address withAudioId:(NSNumber *)audioID;
@end

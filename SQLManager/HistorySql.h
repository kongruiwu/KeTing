//
//  HistorySql.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"
#import <FMDB.h>

@interface HistorySql : NSObject

@property (nonatomic, strong) FMDatabase * PDO;

+ (instancetype)sql;
- (void)openDB;
- (void)insertAudio:(HomeTopModel *)model;
- (void)updatePlayLong:(NSNumber *)playLong withAudioID:(NSNumber *)audioID;
- (NSNumber *)getPlayLongWithAudioID:(NSNumber *)audioID;
- (BOOL)checkAudio:(NSNumber *)audioID;
- (NSMutableArray *)getAllHistoryAudios;
- (void)deleteAudioWithID:(NSNumber *)audioID;
@end

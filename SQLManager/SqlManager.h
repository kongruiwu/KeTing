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
- (void)insertAudio:(HomeTopModel *)model;
- (void)updateAudioDownStatus:(NSInteger)status withAudioId:(NSNumber *)audioID;
- (void)deleteAudioWithID:(NSNumber *)audioID;
- (NSMutableArray *)getAllDownLoaderStatus;
- (NSNumber *)checkDownStatusWithAudioid:(NSNumber *)audioID;
@end

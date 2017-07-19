//
//  SqlManager.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"
#import <sqlite3.h>
@interface SqlManager : NSObject

{
    sqlite3 * PDO;
}

+ (instancetype)manager;
- (void)openDB;
- (void)creatTable;
- (void)insertAudio:(HomeTopModel *)model;
- (void)updateAudioDownStatus:(NSInteger)status withAudioId:(NSNumber *)audioID;
- (void)deleteAudioWithID:(NSNumber *)audioID;
- (NSMutableArray *)getAllDownLoaderStatus;
- (void)closeDB;

- (int)checkDownLoadStatus:(NSNumber *)audioID;
@end

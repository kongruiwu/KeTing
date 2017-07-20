//
//  SqlManager.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SqlManager.h"

@implementation SqlManager


+ (instancetype)manager{
    static SqlManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[SqlManager alloc]init];
        }
    });
    return manager;
}

- (void)openDB{
    NSArray * sandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * sandBoxPath = sandBox[0];
    NSString * documentPath = [sandBoxPath stringByAppendingPathComponent:@"Keting.sqlite"];
    NSLog(@"数据库地址%@",documentPath);
    // 2.得到数据库
    self.PDO = [FMDatabase databaseWithPath:documentPath];
    // 3.打开数据库
    if ([self.PDO open]) {
        // 4.创表
        BOOL result = [self.PDO executeUpdate:@"CREATE TABLE IF NOT EXISTS audio (id integer PRIMARY KEY AUTOINCREMENT,topId INTEGER,topName TEXT,audioId INTEGER,anchorId INTEGER,columnId INTEGER,audioName TEXT,summary TEXT,audioContent TEXT,audioSource TEXT,audioSize INTEGER,audioLong INTEGER,thumbnail TEXT,anchorName TEXT,isprase INTEGER,downStatus INTEGER,playLong INTEGER,tagString TEXT,localAddress TEXT);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
    
}
- (void)insertAudio:(HomeTopModel *)model{
    NSString *sqlStr=[NSString stringWithFormat:@"insert into audio (topId,topName,audioId,anchorId,columnId,audioName,summary,audioContent,audioSource,audioSize,audioLong,thumbnail,anchorName,isprase,downStatus,playLong,tagString,localAddress) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.topId,model.topName,model.audioId ,model.anchorId ,model.columnId ,model.audioName,model.summary,model.audioContent,model.audioSource,model.audioSize,model.audioLong,model.thumbnail,model.anchorName,@(model.isprase),model.downStatus ,model.playLong,model.tagString,model.localAddress];
    
    [self.PDO executeUpdate:sqlStr];
    
}
- (void)fmdbExecSql:(NSString *)sql{
    if ([self.PDO open]) {
        if ([self.PDO executeUpdate:sql]) {
            NSLog(@"%@%@%@",@"fmdb操作表",@"audio",@"成功！");
        }else{
            NSLog(@"%@%@%@ lastErrorMessage：%@，lastErrorCode：%d",@"fmdb创建",@"audio",@"失败！",self.PDO.lastErrorMessage,self.PDO.lastErrorCode);
        }
    }else{
        NSLog(@"%@",@"fmdb数据库打开失败！");
    }
}

- (void)updateAudioDownStatus:(NSInteger)status withAudioId:(NSNumber *)audioID{
    NSString *sql = [NSString stringWithFormat:@"UPDATE audio set downStatus='%@' WHERE audioId='%@';",@(status),audioID];
    [self fmdbExecSql:sql];
}
- (void)updateAudioLocaltionAddress:(NSString *)address withAudioId:(NSNumber *)audioID{
    NSString *sql = [NSString stringWithFormat:@"UPDATE audio set localAddress='%@' WHERE audioId='%@';",address,audioID];
    [self fmdbExecSql:sql];
}
- (void)deleteAudioWithID:(NSNumber *)audioID{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM audio WHERE audioId='%@';",audioID];
    [self fmdbExecSql:sql];
}

- (NSNumber *)checkDownStatusWithAudioid:(NSNumber *)audioID{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM audio WHERE audioId='%@';",audioID];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    
    if ([resultSet next]) {
        NSNumber * downStatus = [resultSet objectForColumn:@"downStatus"];
        return downStatus;
    }
    return @(1000);
}
- (NSString *)checkAudioLocaltionAddressWithAudioid:(NSNumber *)audioID{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM audio WHERE audioId='%@';",audioID];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    
    if ([resultSet next]) {
        NSString * downStatus = [resultSet objectForColumn:@"localAddress"];
        return downStatus;
    }
    return @"";
}

- (NSMutableArray *)getAllDownLoaderStatus{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM audio WHERE downStatus = 2;"];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    NSMutableArray * audios = [NSMutableArray new];
    //遍历结果集合
    while ([resultSet  next]){
        HomeTopModel * model = [self getModelWithResultset:resultSet];
        [audios addObject:model];
    }
    return audios;
}
- (NSMutableArray *)getDownLoadingAudio{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM audio WHERE downStatus = 1;"];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    NSMutableArray * audios = [NSMutableArray new];
    //遍历结果集合
    while ([resultSet  next]){
        HomeTopModel * model = [self getModelWithResultset:resultSet];
        [audios addObject:model];
    }
    return audios;
}
- (NSMutableArray *)getWaitDownLoadingAudios{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM audio WHERE downStatus == 0;"];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    NSMutableArray * audios = [NSMutableArray new];
    //遍历结果集合
    while ([resultSet  next]){
        HomeTopModel * model = [self getModelWithResultset:resultSet];
        [audios addObject:model];
    }
    return audios;
}
- (HomeTopModel *)getModelWithResultset:(FMResultSet *)resultSet{
    HomeTopModel * model = [[HomeTopModel alloc]init];
    model.topId = [resultSet objectForColumn:@"topId"];
    model.topName = [resultSet objectForColumn:@"topName"];
    model.audioId = [resultSet objectForColumn:@"audioId"];
    model.anchorId = [resultSet objectForColumn:@"anchorId"];
    model.columnId = [resultSet objectForColumn:@"columnId"];
    model.audioName = [resultSet objectForColumn:@"audioName"];
    model.summary = [resultSet objectForColumn:@"summary"];
    model.audioContent = [resultSet objectForColumn:@"audioContent"];
    model.audioSource = [resultSet objectForColumn:@"audioSource"];
    model.audioSize = [resultSet objectForColumn:@"audioSize"];
    model.audioLong = [resultSet objectForColumn:@"audioLong"];
    model.thumbnail = [resultSet objectForColumn:@"thumbnail"];
    model.anchorName = [resultSet objectForColumn:@"anchorName"];
    model.isprase = (int)[resultSet intForColumn:@"isprase"];
    model.downStatus = [resultSet objectForColumn:@"downStatus"];
    model.playLong = [resultSet objectForColumn:@"playLong"];
    model.tagString = [resultSet objectForColumn:@"tagString"];
    model.localAddress = [resultSet objectForColumn:@"localAddress"];
    return model;
}

- (void)closeDB{
    
}
@end

//
//  HistorySql.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HistorySql.h"

@implementation HistorySql


+ (instancetype)sql{
    static HistorySql * sql = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sql) {
            sql = [[HistorySql alloc]init];
        }
    });
    return sql;
}
- (void)openDB{
    NSArray * sandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * sandBoxPath = sandBox[0];
    NSString * documentPath = [sandBoxPath stringByAppendingPathComponent:@"Keting.sqlite"];
    // 2.得到数据库
    self.PDO = [FMDatabase databaseWithPath:documentPath];
    // 3.打开数据库
    if ([self.PDO open]) {
        // 4.创表
        BOOL result = [self.PDO executeUpdate:@"CREATE TABLE IF NOT EXISTS play (id integer PRIMARY KEY AUTOINCREMENT,audioId INTEGER,audioSource TEXT,audioName TEXT,playLong INTEGER,audioSize INTEGER,tagString TEXT,isprase INTEGER,audioContent TEXT,thumbnail TEXT,audioLong INTEGER,relationType INTEGER,relationId INTEGER,praseNum INTEGER,topId INTEGER,summary TEXT);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
}
- (void)insertAudio:(HomeTopModel *)model{
    NSString *sqlStr=[NSString stringWithFormat:@"insert into play (audioId,audioName,audioSource,playLong,audioSize,tagString,isprase,audioContent,thumbnail,audioLong,relationType,relationId,praseNum,topId,summary) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.audioId ,model.audioName,model.audioSource,model.playLong,model.audioSize,model.tagString,@(model.isprase),model.audioContent,model.thumbnail,model.audioLong,model.relationType,model.relationId,model.praseNum,model.topId,model.summary];
    
    [self.PDO executeUpdate:sqlStr];
    
}
- (void)fmdbExecSql:(NSString *)sql{
    if ([self.PDO open]) {
        if ([self.PDO executeUpdate:sql]) {
            NSLog(@"%@%@%@",@"fmdb操作表",@"play",@"成功！");
        }else{
            NSLog(@"%@%@%@ lastErrorMessage：%@，lastErrorCode：%d",@"fmdb创建",@"play",@"失败！",self.PDO.lastErrorMessage,self.PDO.lastErrorCode);
        }
    }else{
        NSLog(@"%@",@"fmdb数据库打开失败！");
    }
}
- (void)updatePlayLong:(NSNumber *)playLong withAudioID:(NSNumber *)audioID{
    NSString *sql = [NSString stringWithFormat:@"UPDATE play set playLong='%@' WHERE audioId='%@';",playLong,audioID];
    [self fmdbExecSql:sql];
}
- (NSNumber *)getPlayLongWithAudioID:(NSNumber *)audioID{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM play WHERE audioId='%@';",audioID];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    
    if ([resultSet next]) {
        NSNumber * playLong = [resultSet objectForColumn:@"playLong"];
        return playLong;
    }
    return @0;
}
- (BOOL)checkAudio:(NSNumber *)audioID{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM play WHERE audioId='%@';",audioID];
    //根据条件查询
    FMResultSet *resultSet = [self.PDO executeQuery:sqlQuery];
    return [resultSet next];
    
}
- (NSMutableArray *)getAllHistoryAudios{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM play;"];
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
- (void)updateAudioWithModel:(HomeTopModel *)model{
    [self deleteAudioWithID:model.audioId];
    [self insertAudio:model];
}
- (void)deleteAudioWithID:(NSNumber *)audioID{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM play WHERE audioId='%@';",audioID];
    [self fmdbExecSql:sql];
}
- (HomeTopModel *)getModelWithResultset:(FMResultSet *)result{
    HomeTopModel * model = [[HomeTopModel alloc]init];
    /*
     audioId,audioName,audioSource,playLong,audioSize,tagString,isprase,audioContent,thumbnail
     */
    model.topId = [result objectForColumn:@"topId"];
    model.summary = [result objectForColumn:@"summary"];
    model.audioId = [result objectForColumn:@"audioId"];
    model.audioName = [result objectForColumn:@"audioName"];
    model.audioSource = [result objectForColumn:@"audioSource"];
    model.playLong = [result objectForColumn:@"playLong"];
    model.audioSize = [result objectForColumn:@"audioSize"];
    model.tagString = [result objectForColumn:@"tagString"];
    NSNumber * num = [result objectForColumn:@"isprase"];
    model.isprase = [num boolValue];
    model.audioContent = [result objectForColumn:@"audioContent"];
    model.thumbnail = [result objectForColumn:@"thumbnail"];
    model.audioLong = [result objectForColumn:@"audioLong"];
    model.relationId = [result objectForColumn:@"relationId"];
    model.relationType = [result objectForColumn:@"relationType"];
    model.praseNum = [result objectForColumn:@"praseNum"];
    return model;
}
@end

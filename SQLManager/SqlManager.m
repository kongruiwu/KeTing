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
    int result=sqlite3_open([documentPath UTF8String], &PDO);
    if (result==SQLITE_OK) {
        NSLog(@"数据库打开成功");
        NSLog(@"%@",documentPath);
        
    }else{
        NSLog(@"数据库打开失败");
    }
}
- (void)creatTable{
    NSString *sqlStr=@" create table if not exists audio(number integer primary key autoincrement,topId INTEGER,topName TEXT,audioId INTEGER,anchorId INTEGER,columnId INTEGER,audioName TEXT,summary TEXT,audioContent TEXT,audioSource TEXT,audioSize INTEGER,audioLong INTEGER,thumbnail TEXT,anchorName TEXT,isprase INTEGER,downStatus INTEGER,playLong INTEGER,tagString TEXT)";
    //执行这条sql语句
    int result= sqlite3_exec (PDO, [sqlStr UTF8String], nil, nil, nil);
    
    if (result==SQLITE_OK) {
        NSLog(@"表创建成功");
    }else{
        NSLog(@"表创建失败");
    }
}
- (void)insertAudio:(HomeTopModel *)model{
    NSString *sqlStr=[NSString stringWithFormat:@"insert into audio (topId,topName,audioId,anchorId,columnId,audioName,summary,audioContent,audioSource,audioSize,audioLong,thumbnail,anchorName,isprase,downStatus,playLong,tagString) values ('%ld','%@','%ld','%ld','%ld','%@','%@','%@','%@','%ld','%ld','%@','%@','%ld','%ld','%ld','%@')",[model.topId integerValue],model.topName,[model.audioId integerValue],[model.anchorId integerValue],[model.columnId integerValue],model.audioName,model.summary,model.audioContent,model.audioSource,[model.audioSize longValue],[model.audioLong integerValue],model.thumbnail,model.anchorName,[@(model.isprase) integerValue],[model.downStatus integerValue],[model.playLong integerValue],model.tagString];
    
    int result=sqlite3_exec(PDO, [sqlStr UTF8String], nil, nil, nil);
    if (result==SQLITE_OK) {
        NSLog(@"添加音频成功");
    }else {
        NSLog(@"添加音频失败");
    }
}
- (int)checkDownLoadStatus:(NSNumber *)audioID{
    NSString *sqlStr= [NSString stringWithFormat:@"select downStatus from audio where audioId='%ld'",[audioID integerValue]];
    sqlite3_stmt *stmt=nil;
    int result = sqlite3_prepare_v2(PDO, [sqlStr UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        int downStatus = sqlite3_column_int(stmt, 14);
        NSLog(@"查询成功");
        return downStatus;
    }else{
        NSLog(@"查询失败");
        NSLog(@"%d",result);
        return -1;
    }
    
}
- (void)updateAudioDownStatus:(NSInteger)status withAudioId:(NSNumber *)audioID{
    NSString *sqlStr= [NSString stringWithFormat:@"update audio set downStatus='%ld' where audioId='%ld'",status,[audioID integerValue]];
    //执行sql语句
    int result=sqlite3_exec(PDO, [sqlStr UTF8String], nil, nil, nil);
    if (result==SQLITE_OK) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
        NSLog(@"%d",result);
    }
}
- (void)deleteAudioWithID:(NSNumber *)audioID{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from audio where audioId='%ld'",[audioID integerValue]];
    int result=sqlite3_exec(PDO, [sqlStr UTF8String], nil, nil, nil);
    if (result==SQLITE_OK) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

- (NSMutableArray *)getAllDownLoaderStatus{
    NSString *sqlStr=@"select * from audio where downStatus=1";
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(PDO, [sqlStr UTF8String], -1, &stmt, nil);
     NSMutableArray * audios = [NSMutableArray array];
    if (result==SQLITE_OK) {
        NSLog(@"查询成功");
        //开始遍历查询数据库的每一行数据
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            //让跟随指针进行遍历查询,如果没有行,才会停止循环
            //满足条件,则逐列的读取内容
//            //第二个参数表示当前这列数据在表的第几列
//            const unsigned char *name=sqlite3_column_text(stmt, 1);
//            int age=sqlite3_column_int(stmt, 2);
//            const unsigned char *hobby=sqlite3_column_text(stmt,3);
            //把列里的数据再进行类型的转换
//            NSInteger stuAge=age;
//            NSString *stuName=[NSString stringWithUTF8String:(const char *)name];
//            NSString *stuHobby=[NSString stringWithUTF8String:(const char *)hobby];
//            //给对象赋值,然后把对象放到数组里
//            Student *stu=[[Student alloc] init];
//            
//            
        }
        
        
        
    }else{
        NSLog(@"查询失败");
        NSLog(@"%d",result);
    }
    return audios;
}
- (void)closeDB{
    int result=sqlite3_close(PDO);
    if (result==SQLITE_OK) {
        NSLog(@"数据库关闭成功");
        // NSLog(@"%@",documentPath);
    }else{
        NSLog(@"数据库关闭失败");
    }
}
@end

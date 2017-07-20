//
//  AudioDownLoader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioDownLoader.h"
#import "ToastView.h"
@interface AudioDownLoader()


@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;
@property (nonatomic, strong) NSData * resumeData;
@property (nonatomic, strong) NSFileManager * fileManager;


@end

/**
 存储 所有队列
 
 
 */


@implementation AudioDownLoader

+ (instancetype)loader{
    static AudioDownLoader * loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!loader) {
            loader = [[AudioDownLoader alloc]init];
            loader.fileManager = [NSFileManager defaultManager];
            //先获取本地 正在下载音频 和 未下载音频
            loader.currentModel = nil;
            NSMutableArray * loading = [[SqlManager manager] getDownLoadingAudio];
            if (loading.count>0) {
                loader.currentModel = loading[0];
            }
            loader.downLoadList = [NSMutableArray new];
            NSMutableArray * muarr = [[SqlManager manager] getWaitDownLoadingAudios];
            if (loader.currentModel) {
                [muarr addObject:loader.currentModel];
            }
            if (muarr.count > 0) {
                loader.downLoadList = muarr;
            }
            NSURLSessionConfiguration * cfg = [NSURLSessionConfiguration defaultSessionConfiguration]; // 默认配置
            loader.session = [NSURLSession sessionWithConfiguration:cfg delegate:loader delegateQueue:[NSOperationQueue mainQueue]];
        }
    });
    return loader;
}
- (void)deleteAudioWithLocalPath:(NSString *)LocalPath{
    [self.fileManager removeItemAtPath:LocalPath error:nil];
}

- (void)downLoadAudioWithHomeTopModel:(NSArray *)topModels{
    [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"音频已开始下载。。。" duration:1.0f];
    for (int i = 0; i<topModels.count; i++) {
         //先将数据存储到数据库  然后在下载完成后修改数据下载状态
        [[SqlManager manager] insertAudio:topModels[i]];
    }
    
    [self.downLoadList addObjectsFromArray:topModels];
    if (!self.currentModel) {
        self.currentModel = [self.downLoadList firstObject];
    }
    //刚开始下载的音频  刷新数据库中downloadstatus
    [[SqlManager manager] updateAudioDownStatus:1 withAudioId:self.currentModel.audioId];
    
    NSURL * url = [NSURL URLWithString:self.currentModel.audioSource];
    
    // 创建任务
    self.downloadTask = [self.session downloadTaskWithURL:url];
    
    // 开始任务
    [self.downloadTask resume];
}
//暂停下载
- (void)cancelDownLoading{
    if (!self.currentModel) {
        return;
    }
    __weak typeof(self) weakself = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
       // resumeData 暂停后的 尚未下载完的数据
        weakself.resumeData = resumeData;
        weakself.downloadTask = nil;
        if (![self.fileManager fileExistsAtPath:TemCachesPath]) {
            [self.fileManager createDirectoryAtPath:TemCachesPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        NSArray * paths = [weakself.fileManager subpathsAtPath:NSTemporaryDirectory()];
        for (NSString *filePath in paths)
        {
            if ([filePath rangeOfString:@"CFNetworkDownload"].length>0)
            {
                NSString * tmpPath = [TemCachesPath stringByAppendingPathComponent:filePath];
                NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath];
                [weakself.fileManager copyItemAtPath:path toPath:tmpPath error:nil];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:resumeData forKey:@"resumeData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }];
}
//开始下载
- (void)resumeDownLoading{
    NSMutableArray * arr = [[SqlManager manager] getDownLoadingAudio];
    if (arr.count >0) {
        self.currentModel = arr[0];
    }else{
        NSMutableArray * arr = [[SqlManager manager] getWaitDownLoadingAudios];
        if (arr.count == 0) {
            return;
        }else{
            self.currentModel = arr[0];
        }
    }
    if (!self.currentModel) {
        return;
    }
    NSArray *paths = [self.fileManager subpathsAtPath:TemCachesPath];
    for (NSString *filePath in paths)
    {
        if ([filePath rangeOfString:@"CFNetworkDownload"].length>0)
        {
            NSString * temp = [TemCachesPath stringByAppendingPathComponent:filePath];
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath];
            [self.fileManager copyItemAtPath:temp toPath:path error:nil];
            [self.fileManager removeItemAtPath:TemCachesPath error:nil];
        }
    }
    if (!self.resumeData) {
        self.resumeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"resumeData"];
    }
    
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
}
#pragma mark -- NSURLSessionDownloadDelegate


/**
 *  下载完毕会调用
 *
 *  @param location     文件临时地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    /*
            存储元数据
            获取地址
            数据库 存入            audioid   isDownLoading  url
     */
    if ([self.delegate respondsToSelector:@selector(audioDownLoadOver)]) {
        [self.delegate audioDownLoadOver];
    }
    if (![self.fileManager fileExistsAtPath:HSCachesDirectory]) {
        [self.fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // 下载成功
    // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
    NSError *saveError;
    NSURL * saveURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",HSCachesDirectory,self.currentModel.audioId]];
    
    // 文件复制到cache路径中
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];
    //下载成功之后 修改本地数据库 修改下载状态 与本地地址
    [[SqlManager manager] updateAudioDownStatus:2 withAudioId:self.currentModel.audioId];
    [[SqlManager manager] updateAudioLocaltionAddress:[NSString stringWithFormat:@"%@",saveURL] withAudioId:self.currentModel.audioId];
    //删除已下载的音频，重新开始下一个音频下载
    [self.downLoadList removeObject:self.currentModel];
    self.currentModel = nil;
    if (self.downLoadList.count >0) {
        self.currentModel = self.downLoadList[0];
        NSURL * url = [NSURL URLWithString:self.currentModel.audioSource];
        // 创建任务
        self.downloadTask = [self.session downloadTaskWithURL:url];
        // 开始任务
        [self.downloadTask resume];
    }
}
/**
 *  每次写入沙盒完毕调用
 *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
 *
 *  @param bytesWritten              这次写入的大小
 *  @param totalBytesWritten         已经写入沙盒的大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    NSLog(@"%@",[NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite]);
}

/**
 *  恢复下载后调用，
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

@end

//
//  AudioDownLoader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioDownLoader.h"

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
            loader.downLoadList = [NSMutableArray new];
            NSURLSessionConfiguration * cfg = [NSURLSessionConfiguration defaultSessionConfiguration]; // 默认配置
            loader.session = [NSURLSession sessionWithConfiguration:cfg delegate:loader delegateQueue:[NSOperationQueue mainQueue]];
        }
    });
    return loader;
}

- (void)downLoadAudioWithHomeTopModel:(NSArray *)topModels{
    
    [self.downLoadList addObjectsFromArray:topModels];
    
    self.currentModel = [topModels firstObject];
    
    NSURL * url = [NSURL URLWithString:self.currentModel.audioSource];
    
    // 创建任务
    self.downloadTask = [self.session downloadTaskWithURL:url];
    
    // 开始任务
    [self.downloadTask resume];
}
//暂停下载
- (void)cancelDownLoading{
    
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
    NSArray *paths = [self.fileManager subpathsAtPath:TemCachesPath];
    for (NSString *filePath in paths)
    {
        if ([filePath rangeOfString:@"CFNetworkDownload"].length>0)
        {
            NSString * temp = [TemCachesPath stringByAppendingPathComponent:filePath];
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:filePath];
            //反向移动
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
    NSLog(@"文件临时地址 %@",location);
    /*
            存储元数据
            获取地址
            数据库 存入            audioid   isDownLoading  url
     */
    if (![self.fileManager fileExistsAtPath:HSCachesDirectory]) {
        [self.fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    // 下载成功
    // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
    NSError *saveError;
    NSURL * saveURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.mp3",HSCachesDirectory,self.currentModel.audioName]];
    
    // 文件复制到cache路径中
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];
    NSLog(@"文件保存地址:%@",saveURL);
    if (!saveError) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"error is %@", saveError.localizedDescription);
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

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

@end


@implementation AudioDownLoader

+ (instancetype)loader{
    static AudioDownLoader * loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!loader) {
            loader = [[AudioDownLoader alloc]init];
        }
    });
    return loader;
}

- (void)downLoadAudioWithHomeTopModel:(HomeTopModel *)model{
    
    self.currentModel = model;
    
    NSURL * url = [NSURL URLWithString:model.audioSource];
    
    NSURLSessionConfiguration* cfg = [NSURLSessionConfiguration defaultSessionConfiguration]; // 默认配置
    
    self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
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
    }];
}
//开始下载
- (void)resumeDownLoading{
   self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    NSString * filepath = [NSString stringWithFormat:@"%@/Documents/audio/%@",str1,[NSString stringWithFormat:@"%@.mp3",self.currentModel.audioName]];
    if (![fileManager fileExistsAtPath:filepath]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"audio"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [directryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.currentModel.audioName]];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSLog(@"文件临时地址 %@",location);
    // 下载成功
    // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
    NSError *saveError;
    // 创建一个自定义存储路径
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *savePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.currentModel.audioName]];
    NSURL *saveURL = [NSURL fileURLWithPath:savePath];
    
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
//    self.pgLabel.text = [NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite];
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
